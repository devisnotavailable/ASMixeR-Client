abstract class ChannelEvent {}

class LoadChannelEvent extends ChannelEvent {
  final String channelID;

  LoadChannelEvent(this.channelID);
}

class ChannelClickEvent extends ChannelEvent {
  final String channelID;

  ChannelClickEvent(this.channelID);
}

class VideoClickEvent extends ChannelEvent {
  final String videoID;

  VideoClickEvent(this.videoID);
}
