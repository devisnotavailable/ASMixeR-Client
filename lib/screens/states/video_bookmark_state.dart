import '../../data/entities/video.dart';

class VideoBookmarkState {
  final List<String> bookmarkIDs;
  final List<Video> bookmarkedVideos;
  final bool videosLoaded;

  VideoBookmarkState(
      this.bookmarkIDs, this.bookmarkedVideos, this.videosLoaded);

  VideoBookmarkState copyWith(
      {List<String>? bookmarkIDs,
      List<Video>? bookmarkedVideos,
      bool? videosLoaded}) {
    return VideoBookmarkState(
        bookmarkIDs ?? this.bookmarkIDs,
        bookmarkedVideos ?? this.bookmarkedVideos,
        videosLoaded ?? this.videosLoaded);
  }
}
