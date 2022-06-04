import 'package:flutter/material.dart';

enum PlayerMode { INIT, PAUSED, PLAYING, FINISHED, AUDIO_CHANGED }

@immutable
class AudioPlayerState {
  final PlayerMode mode;

  const AudioPlayerState(this.mode);
}

class ErrorState extends AudioPlayerState {
  final String error;

  const ErrorState(playerState, this.error) : super(playerState);
}
