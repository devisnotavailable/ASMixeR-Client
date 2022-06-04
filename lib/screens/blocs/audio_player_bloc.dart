import 'dart:async';

import 'package:asmixer/screens/events/audio_player_event.dart';
import 'package:asmixer/screens/states/audio_player_state.dart';
import 'package:asmixer/services/audio_handler.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final AppAudioHandler _audioHandler;

  AudioPlayerBloc(this._audioHandler)
      : super(const AudioPlayerState(PlayerMode.INIT)) {
    on<PlayerInitEvent>(_onInitEvent);
    on<PlayEvent>(_onPlayEvent);
    on<PauseEvent>(_onPauseEvent);
    on<AddToPlaylistEvent>(_onAddToPlaylist);
    on<AudioChangedEvent>(_onAudioChanged);
    on<ResetPlayerEvent>(_onResetPlayerEvent);
  }

  void _startListeningAudioHandler() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (state.mode != PlayerMode.INIT) {
        if (!isPlaying) {
          add(PauseEvent());
        } else if (processingState != AudioProcessingState.completed) {
          add(PlayEvent());
        }
      }
    });
  }

  _onResetPlayerEvent(ResetPlayerEvent event, Emitter emit) {
    _audioHandler.stop();
    emit(const AudioPlayerState(PlayerMode.INIT));
  }

  void _startListeningToAudioChange() {
    _audioHandler.mediaItem.listen((mediaItem) {
      // var id = int.parse(mediaItem!.id);
      add(AudioChangedEvent());
    });
  }

  FutureOr<void> _onInitEvent(PlayerInitEvent event, Emitter emit) {
    _startListeningAudioHandler();
    _startListeningToAudioChange();
  }

  FutureOr<void> _onPlayEvent(AudioPlayerEvent event, Emitter emit) {
    _audioHandler.play();
    emit(const AudioPlayerState(PlayerMode.PLAYING));
  }

  FutureOr<void> _onAudioChanged(AudioChangedEvent event, Emitter emit) {
    emit(const AudioPlayerState(PlayerMode.AUDIO_CHANGED));
  }

  FutureOr<void> _onPauseEvent(PauseEvent event, Emitter emit) {
    _audioHandler.pause();
    emit(const AudioPlayerState(PlayerMode.PAUSED));
  }

  FutureOr<void> _onAddToPlaylist(AddToPlaylistEvent event, Emitter emit) {
    //start listening to audioHandler streams on first addEvent
    if (state.mode == PlayerMode.INIT) {
      add(PlayerInitEvent());
    }

    var item = MediaItem(
      id: DateTime.now()
          .millisecondsSinceEpoch
          .toString(), //unique id, does current time work? it should
      title: event.title,
      album: event.albumTitle,
      extras: {'path': event.path},
    );

    _audioHandler.addQueueItems([item]);

    if (state.mode == PlayerMode.INIT) {
      add(PlayEvent()); //only add play event first time to prevent unpausing in a rare situations
    }
  }
}
