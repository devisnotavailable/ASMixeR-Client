import '../../data/entities/profile.dart';

abstract class AudioTransformEvent {}

class CreateNewAudioEvent extends AudioTransformEvent {
  final Profile? profile; //if null - use old profile

  CreateNewAudioEvent([this.profile]);
}
