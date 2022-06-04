import 'dart:io';
import 'dart:math';

import 'package:asmixer/database/database.dart';
import 'package:asmixer/screens/events/audio_sample_play_event.dart';
import 'package:asmixer/screens/states/category_play_state.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';

class CategoryPlayBloc extends Bloc<AudioSamplePlayEvent, CategoryPlayState> {
  final _player = AudioPlayer();
  Directory directory;
  AppDatabase appDatabase;

  CategoryPlayBloc(CategoryPlayState initialState,
      {required this.directory, required this.appDatabase})
      : super(initialState) {
    _listenToPlaybackEvents();
    on<PlaybackChangeEvent>(_onPlaybackChangedEvent);
    on<AudioCompletedEvent>(_onAudioCompletedEvent);
  }

  _onPlaybackChangedEvent(PlaybackChangeEvent event, Emitter emit) {
    if (event.categoryID == state.categoryID) {
      if (!state.playing) {
        _startPlaying(event.categoryID);
      } else {
        _player.stop();
      }
      emit(CategoryPlayState(!state.playing, event.categoryID));
    } else {
      if (state.playing) {
        _player.stop();
      }
      _startPlaying(event.categoryID);
      emit(CategoryPlayState(true, event.categoryID));
    }
  }

  _startPlaying(categoryID) async {
    var listByCategory =
        await appDatabase.audioToCategoryDao.getByCategory(categoryID);
    var randomID = Random.secure().nextInt(listByCategory!.length);
    var audioSample = await appDatabase.audioSampleDao
        .getByID(listByCategory[randomID].audioSampleID);
    _player.setFilePath(audioSample!.path);
    _player.play();
  }

  _onAudioCompletedEvent(AudioCompletedEvent event, Emitter emit) {
    emit(CategoryPlayState(false, state.categoryID));
  }

  _listenToPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      if (event.processingState == ProcessingState.completed) {
        add(AudioCompletedEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
