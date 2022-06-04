import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:asmixer/data/entities/audio_sample.dart';
import 'package:asmixer/data/entities/audio_sample_to_category.dart';
import 'package:asmixer/database/database.dart';
import 'package:asmixer/screens/events/audio_transform_event.dart';
import 'package:asmixer/screens/states/audio_transform_state.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:path/path.dart';

import '../../data/entities/profile.dart';
import '../../data/entities/profile_to_category.dart';

class AudioTransformBloc
    extends Bloc<AudioTransformEvent, AudioTransformState> {
  final AppDatabase appDatabase;
  final int fadeOutOffset = 2; //start fadeOut 1 second before the sample ends
  final int fadeInDuration = 4;
  final int fadeOutDuration = 4;
  final String fadeOutOutputNameFirst = 'fadeOutput1.mp3';
  final String fadeOutOutputNameSecond = 'fadeOutput2.mp3';
  late Profile activeProfile;
  List<AudioSample> audioSamples = [];
  int currentSampleIndex = 0;

  Directory directory;

  AudioTransformBloc({required this.directory, required this.appDatabase})
      : super(TransformInitState()) {
    on<CreateNewAudioEvent>(_onCreateAudioEvent, transformer: sequential());
  }

  Future<List<AudioSample>> _getAudioSamples(int profileID) async {
    List<ProfileToCategory> profileToCategoryList =
        await appDatabase.profileToCategoryDao.getCategoriesIDs(profileID) ??
            [];

    List<AudioSample> audioSamples = [];
    for (var profileToCategory in profileToCategoryList) {
      List<AudioSampleToCategory> sampleToCategoryList = await appDatabase
              .audioToCategoryDao
              .getByCategory(profileToCategory.categoryID) ??
          [];

      List<AudioSample> categorySamples = [];
      for (var sampleToCategory in sampleToCategoryList) {
        var audioSample = await appDatabase.audioSampleDao
            .getByID(sampleToCategory.audioSampleID);
        categorySamples.add(audioSample!);
      }

      audioSamples.addAll(categorySamples);
    }

    //remove duplicates with toSet, then convert back toList for convenience functions
    return audioSamples.toSet().toList()..shuffle(Random.secure());
  }

  _createAudio(Emitter emit) async {
    if (currentSampleIndex >= audioSamples.length) {
      _onAllSamplesPlayed();
    }
    var assetPath = audioSamples[currentSampleIndex].path;
    var session = await FFprobeKit.getMediaInformation(assetPath);
    String? stringDuration = session.getMediaInformation()?.getDuration();
    if (stringDuration != null) {
      int duration = double.parse(stringDuration).toInt();

      var first = currentSampleIndex == 0;
      var fadeOutputName = first
          ? fadeOutOutputNameFirst
          : fadeOutOutputNameSecond; //to prevent file corruption
      var startTime = duration - fadeOutOffset;
      var outputPath = join(directory.path, fadeOutputName);
      var session = await FFmpegKit.execute(
          '-y -i $assetPath -af "afade=in:d=$fadeInDuration:st=0,afade=out:d=$fadeOutDuration:st=$startTime" $outputPath');
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        emit(AudioReadyState(outputPath, activeProfile));
        currentSampleIndex += 1;
      } else if (ReturnCode.isCancel(returnCode)) {
        emit(ErrorState("Cancelled"));
      } else {
        emit(ErrorState("Something Went Wrong"));
      }
    }
  }

  _initDataForProfile(int profileID) async {
    currentSampleIndex = 0;
    audioSamples = await _getAudioSamples(profileID);
  }

  _onAllSamplesPlayed() {
    //shuffle and go another round
    audioSamples.shuffle(Random.secure());
    currentSampleIndex = 0;
  }

  FutureOr<void> _onCreateAudioEvent(
      CreateNewAudioEvent event, Emitter<AudioTransformState> emit) async {
    emit(MergingState());
    //if mix with new profile
    if (event.profile != null) {
      activeProfile = event.profile!;
      await _initDataForProfile(activeProfile.id!);
    }
    if (audioSamples.isNotEmpty) {
      await _createAudio(emit);
    } else {
      emit(ErrorState("No samples for this profile!"));
    }
  }
}
