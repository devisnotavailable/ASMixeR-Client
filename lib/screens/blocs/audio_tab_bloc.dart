import 'dart:io';

import 'package:asmixer/data/entities/audio_sample.dart';
import 'package:asmixer/data/entities/audio_sample_to_category.dart';
import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/database/database.dart';
import 'package:asmixer/network/api_response.dart';
import 'package:asmixer/network/asmixer_repository.dart';
import 'package:asmixer/network/samples_response.dart';
import 'package:asmixer/screens/events/library_event.dart';
import 'package:asmixer/screens/states/library_state.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../../network/sample_response.dart';

class AudioTabBloc extends Bloc<AudioTabEvent, AudioTabState> {
  AppDatabase appDatabase;
  MixerRepository mixerRepository;
  Directory directory;
  late CancelToken downloadCancelToken;
  Dio dio = Dio();
  List<SampleResponse> serverSamples = [];

  AudioTabBloc(AudioTabState initialState,
      {required this.appDatabase,
      required this.mixerRepository,
      required this.directory})
      : super(initialState) {
    on<LoadCategoryEvent>(_onLoad);
    on<UpdateCategoriesEvent>(_onUpdate);
    on<DownloadSamplesEvent>(_onDownload);
    on<CancelDownloadEvent>(_onCancelDownload);
  }

  _onLoad(LoadCategoryEvent event, Emitter emit) async {
    List<Category> listCategory =
        await appDatabase.categoryDao.getAudioCategories();

    emit(state.copyWith(categoryList: listCategory));
  }

  _deleteCategories(List<Category> serverCategories) async {
    //deletes categories that are no longer present on server
    for (var clientCategory in state.categoryList) {
      if (!serverCategories.contains(clientCategory)) {
        await appDatabase.categoryDao.deleteEntity(clientCategory);
      }
    }
  }

  _deleteSamples(List<SampleResponse> serverSamples) async {
    //deletes samples that are no longer present on server
    //TODO: delete files
    var clientSamples = await appDatabase.audioSampleDao.getAudioSamples();
    for (var clientSample in clientSamples) {
      if (serverSamples
          .where((serverSample) => serverSample.id == clientSample.id)
          .toList()
          .isEmpty) {
        await appDatabase.audioSampleDao.deleteEntity(clientSample);
      }
    }
  }

  Future<int> _updateToDownloadCount() async {
    //totalToDownload - is used to determine if we have samples to update
    //toDownloadCount = samples to update + new samples
    //a little bit unoptimized but idc for now
    int totalToDownload = 0;
    List<Category> categoryList =
        await appDatabase.categoryDao.getAudioCategories();
    for (var category in categoryList) {
      int toDownload = 0;
      List<AudioSampleToCategory>? audioToCategoryList =
          await appDatabase.audioToCategoryDao.getByCategory(category.id);
      toDownload +=
          category.serverCount - audioToCategoryList!.length; //new samples
      var samplesToUpdate =
          await _getSamplesToUpdate(serverSamples, category.id);
      toDownload += samplesToUpdate.length; //samples we need to update
      totalToDownload += toDownload;
      await appDatabase.categoryDao
          .updateEntity(category.withUpdateCount(toDownload));
    }
    return totalToDownload;
  }

  Future<int> _update() async {
    var response = await mixerRepository.getCategories();
    await _deleteCategories(
        response.categoryList); //delete no longer used categories
    for (var category in response.categoryList) {
      var oldCategory = await appDatabase.categoryDao.getCategoryByID(
          category.id); //have to update if already exists because floor sucks
      oldCategory == null
          ? await appDatabase.categoryDao.insertEntity(category)
          : await appDatabase.categoryDao.updateEntity(category);
    }

    var samplesResponse = await mixerRepository.getSamples();
    serverSamples = samplesResponse.samplesInfo; //save to use after download
    await _deleteSamples(serverSamples); //delete no longer used samples
    var toDownloadCount = await _updateToDownloadCount();
    return toDownloadCount;
  }

  _onUpdate(UpdateCategoriesEvent event, Emitter emit) async {
    emit(state.copyWith(
        categoryList: state.categoryList, apiResponse: ApiResponse.loading()));
    try {
      var toDownloadCount = await _update();
      emit(CategoryUpdateFinishedState.fromState(
          state.copyWith(
              categoryList: await appDatabase.categoryDao.getAudioCategories(),
              apiResponse: ApiResponse.completed(null)),
          hasUpdates: toDownloadCount > 0));
    } catch (exception) {
      print(exception.toString());
      emit(CategoryUpdateFinishedState.fromState(state.copyWith(
          apiResponse: ApiResponse.error(exception.toString()))));
    }
  }

  Future<List<SampleResponse>> _getSamplesToUpdate(
      List<SampleResponse> serverSamples, int categoryID) async {
    //returns list of samples that needs updates
    List<SampleResponse> audioSampleList = [];
    List<AudioSampleToCategory>? audioToCategoryList =
        await appDatabase.audioToCategoryDao.getByCategory(categoryID);

    for (var audioToCategory in audioToCategoryList!) {
      AudioSample? sample = await appDatabase.audioSampleDao
          .getByID(audioToCategory.audioSampleID);
      var sampleToUpdate = serverSamples.where((serverSample) =>
          serverSample.id == sample!.id &&
          serverSample.lastEditDate >
              sample
                  .lastEditDate); //actually only 1 result but this way it's simpler
      audioSampleList.addAll(sampleToUpdate);
    }

    return audioSampleList;
  }

  Future<List<SampleResponse>> _getSamplesToDownload(
      DownloadSamplesEvent event, SamplesResponse samplesResponse) async {
    //returns list of new samples
    var categoryToAudioSample =
        (await appDatabase.audioToCategoryDao.getByCategory(event.categoryID))
            ?.map((e) => e.audioSampleID);
    return samplesResponse.samplesInfo
        .where((sampleInfo) => !categoryToAudioSample!.contains(sampleInfo.id))
        .toList();
  }

  _onDownload(DownloadSamplesEvent event, Emitter emit) async {
    emit(state.copyWith(
        downloadingID: event.categoryID,
        downloadStatus: DownloadStatus.fetchingDownload));

    try {
      if (serverSamples.isEmpty) {
        //if user pressed download before actually checking for updates (toDownloadCount from previous app launch)
        await _update();
      }
      SamplesResponse samplesResponse =
          await mixerRepository.getSamplesForCategory(event.categoryID);
      List<SampleResponse> samplesToDownload = await _getSamplesToUpdate(
          samplesResponse.samplesInfo, event.categoryID);
      samplesToDownload
          .addAll(await _getSamplesToDownload(event, samplesResponse));

      double totalProgress = 0;
      downloadCancelToken = CancelToken();

      emit(state.copyWith(downloadStatus: DownloadStatus.downloading));

      for (var sampleInfo in samplesToDownload) {
        var path = '${directory.path}/samples/${sampleInfo.name}.mp3';
        double partMaxProgress = 1 / samplesToDownload.length;
        await dio.download(sampleInfo.link, path,
            cancelToken: downloadCancelToken, onReceiveProgress: (cur, total) {
          double currentProgress = cur / total * partMaxProgress;
          emit(state.copyWith(progress: totalProgress + currentProgress));
        });
        totalProgress += partMaxProgress;

        await appDatabase.audioSampleDao.insertEntity(AudioSample(
            id: sampleInfo.id,
            name: sampleInfo.name,
            path: path,
            lastEditDate: sampleInfo.lastEditDate));

        for (var categoryID in sampleInfo.categoryIDList) {
          await appDatabase.audioToCategoryDao.insertEntity(
              AudioSampleToCategory(
                  audioSampleID: sampleInfo.id, categoryID: categoryID));
        }
      }

      await _updateToDownloadCount();
      emit(state.copyWith(
          categoryList: await appDatabase.categoryDao.getAudioCategories(),
          downloadStatus: DownloadStatus.downloaded));
    } on DioError catch (e) {
      print(e.message);
      if (e.type != DioErrorType.cancel) {
        emit(DownloadFailedState.fromState(state));
      }
    } catch (e) {
      print(e.toString());
      emit(DownloadFailedState.fromState(state));
    }

    emit(state.copyWith(downloadingID: -1, progress: 0.0));
  }

  _onCancelDownload(CancelDownloadEvent event, Emitter emit) {
    downloadCancelToken.cancel();
    emit(state.copyWith(downloadingID: -1, progress: 0.0));
  }
}
