import '../../data/entities/video.dart';
import '../../network/api_response.dart';

class VideoTabState {
  final List<Video> videoList; //only last page (PagedListView)
  final ApiResponse? videoResponse;

  VideoTabState(this.videoList, this.videoResponse);
}
