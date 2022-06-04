import 'package:flutter/cupertino.dart';

import '../../data/entities/profile.dart';

@immutable
abstract class AudioTransformState {}

class TransformInitState extends AudioTransformState {}

class WorkingState extends AudioTransformState {}

class FadeInFadeOutState extends WorkingState {}

class MergingState extends WorkingState {}

class AudioReadyState extends AudioTransformState {
  final String path;
  final Profile activeProfile;

  AudioReadyState(this.path, this.activeProfile);
}

class ErrorState extends AudioTransformState {
  final String error;

  ErrorState(this.error);
}
