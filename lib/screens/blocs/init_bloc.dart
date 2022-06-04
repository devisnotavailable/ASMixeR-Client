import 'dart:convert';
import 'dart:io';

import 'package:asmixer/data/entities/audio_sample.dart';
import 'package:asmixer/data/entities/audio_sample_to_category.dart';
import 'package:asmixer/data/entities/profile.dart';
import 'package:asmixer/data/entities/profile_to_category.dart';
import 'package:asmixer/database/database.dart';
import 'package:asmixer/screens/events/init_event.dart';
import 'package:asmixer/screens/states/init_state.dart';
import 'package:asmixer/utils/shared_preferences_utils.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import '../../data/entities/category.dart';

class InitBloc extends Bloc<InitEvent, InitBlocState> {
  final Directory directory;
  final AppDatabase appDatabase;
  final SharedPreferencesUtils sharedPreferencesUtils;

  InitBloc(InitBlocState initialState,
      {required this.directory,
      required this.appDatabase,
      required this.sharedPreferencesUtils})
      : super(initialState) {
    on<InitStartEvent>(_onInitStart);
  }

  _onInitStart(InitStartEvent event, Emitter emit) async {
    emit(const InitBlocState(initState: InitState.WORKING));
    if (sharedPreferencesUtils.isFirstLaunch()) {
      await _copyAssetsToStorage();
      await _createDefaultProfile();
      await _createDefaultCategories();
      await _createProfileToCategories();
      await _createAudioSamples();
      await _createAudioToCategory();
      sharedPreferencesUtils.setFirstLaunch(false);
    }
    emit(const InitBlocState(initState: InitState.COMPLETED));
  }

  _copyAssetsToStorage() async {
    //TODO: do not copy assets to storage, use asset bundle paths by default
    //This function gets all paths from asset folder and copies files to device storage
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final samplePaths = manifestMap.keys
        .where((String key) => key.startsWith('assets/samples/'))
        .toList();

    //Only copy files if samples directory doesn't exist
    Directory samplesDirectory = Directory('${directory.path}/samples/');
    if (!await samplesDirectory.exists()) {
      samplesDirectory = await samplesDirectory.create(recursive: true);
      for (var element in samplePaths) {
        var dbPath = join(
            samplesDirectory.path, element.replaceAll("assets/samples/", ''));
        ByteData data = await rootBundle.load(element);
        List<int> bytes =
            data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes);
      }
    }
  }

  _createDefaultProfile() async {
    final profiles =
        await rootBundle.loadString('assets/json/bundled_profiles.json');
    final List<dynamic> profileJSON = json.decode(profiles);
    for (var profile in profileJSON) {
      await appDatabase.profileDao.insertEntity(Profile.fromJson(profile));
    }
  }

  _createDefaultCategories() async {
    final categories =
        await rootBundle.loadString('assets/json/export_category.json');
    final List<dynamic> categoryJSON = json.decode(categories);
    for (var category in categoryJSON) {
      await appDatabase.categoryDao.insertEntity(Category.fromJson(category));
    }
  }

  _createProfileToCategories() async {
    final profileToCategory = await rootBundle
        .loadString('assets/json/bundled_profile_to_category.json');
    final List<dynamic> profileToCategoryJSON = json.decode(profileToCategory);
    for (var profileToCategory in profileToCategoryJSON) {
      await appDatabase.profileToCategoryDao
          .insertEntity(ProfileToCategory.fromJson(profileToCategory));
    }
  }

  _createAudioSamples() async {
    final samples =
        await rootBundle.loadString('assets/json/export_sample.json');
    final List<dynamic> samplesJSON = json.decode(samples);
    for (var sample in samplesJSON) {
      await appDatabase.audioSampleDao.insertEntity(AudioSample(
          id: sample['id'],
          name: sample['name'],
          path: '${directory.path}/samples/${sample['name']}'));
    }
  }

  _createAudioToCategory() async {
    final categoriesToSample =
        await rootBundle.loadString('assets/json/export_category_sample.json');
    final List<dynamic> categoryToSampleJSON = json.decode(categoriesToSample);
    for (var categoryToSample in categoryToSampleJSON) {
      await appDatabase.audioToCategoryDao
          .insertEntity(AudioSampleToCategory.fromJson(categoryToSample));
    }
  }
}
