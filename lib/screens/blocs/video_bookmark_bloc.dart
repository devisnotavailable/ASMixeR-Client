import 'package:asmixer/data/entities/video_bookmark.dart';
import 'package:asmixer/database/dao/video_bookmark_dao.dart';
import 'package:asmixer/network/youtube_repository.dart';
import 'package:asmixer/screens/events/video_bookmark_event.dart';
import 'package:asmixer/screens/states/video_bookmark_state.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../data/entities/video.dart';
import '../../network/list_video_response.dart';

class VideoBookmarkBloc extends Bloc<VideoBookmarkEvent, VideoBookmarkState> {
  final VideoBookmarkDao videoBookmarkDao;
  final YoutubeRepository youtubeRepository;

  VideoBookmarkBloc(VideoBookmarkState initialState, this.videoBookmarkDao,
      this.youtubeRepository)
      : super(initialState) {
    on<VideoBookmarkChangedEvent>(_onVideoBookmarkChangedEvent,
        transformer: droppable());
    on<VideoBookmarkInitEvent>(_onVideoBookmarkInfoEvent,
        transformer: droppable());
  }

  _onVideoBookmarkChangedEvent(
      VideoBookmarkChangedEvent event, Emitter emit) async {
    var videoBookmark = VideoBookmark(videoID: event.video.videoID);
    List<String> newBookmarkIDs = List.from(state.bookmarkIDs);
    List<Video> newVideoList = List.from(state.bookmarkedVideos);
    if (!state.bookmarkIDs.contains(event.video.videoID)) {
      newBookmarkIDs.add(event.video.videoID);
      newVideoList.add(event.video);
      await videoBookmarkDao.insertEntity(videoBookmark);
    } else {
      newBookmarkIDs.remove(event.video.videoID);
      newVideoList.remove(event.video);
      await videoBookmarkDao.deleteEntity(videoBookmark);
    }
    emit(state.copyWith(
        bookmarkIDs: newBookmarkIDs, bookmarkedVideos: newVideoList));
  }

  _onVideoBookmarkInfoEvent(VideoBookmarkInitEvent event, Emitter emit) async {
    List<VideoBookmark>? videoBookmarks = await videoBookmarkDao.getBookmarks();
    emit(state.copyWith(
        bookmarkIDs: videoBookmarks!
            .map((e) => e.videoID)
            .toList())); //emit only id list at first

    if (state.bookmarkIDs.isNotEmpty) {
      ListVideoResponse videoResponse =
          await youtubeRepository.fetchVideos(videoIDs: state.bookmarkIDs);

      emit(state.copyWith(bookmarkedVideos: videoResponse.videos));
    }

    emit(state.copyWith(videosLoaded: true));
  }
}
