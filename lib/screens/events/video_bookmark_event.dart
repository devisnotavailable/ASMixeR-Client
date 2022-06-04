import '../../data/entities/video.dart';

abstract class VideoBookmarkEvent {}

class VideoBookmarkInitEvent extends VideoBookmarkEvent {}

class VideoBookmarkChangedEvent extends VideoBookmarkEvent {
  final Video video;

  VideoBookmarkChangedEvent(this.video);
}
