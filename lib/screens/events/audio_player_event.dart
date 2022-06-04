abstract class AudioPlayerEvent {}

class PlayEvent extends AudioPlayerEvent {}

class PlayerInitEvent extends AudioPlayerEvent {}

class AddToPlaylistEvent extends AudioPlayerEvent {
  final String title;
  final String albumTitle;
  final String path;

  AddToPlaylistEvent(this.title, this.albumTitle, this.path);
}

class AudioChangedEvent extends AudioPlayerEvent {}

class PauseEvent extends AudioPlayerEvent {}

class SkipSegmentEvent extends AudioPlayerEvent {}

class ResetPlayerEvent extends AudioPlayerEvent {}
