abstract class AudioSamplePlayEvent {}

class PlaybackChangeEvent extends AudioSamplePlayEvent {
  final int categoryID;

  PlaybackChangeEvent(this.categoryID);
}

class PlaybackChangeAudioSampleEvent extends AudioSamplePlayEvent {
  final int idSample;

  PlaybackChangeAudioSampleEvent({required this.idSample});
}

class AudioCompletedEvent extends AudioSamplePlayEvent {}
