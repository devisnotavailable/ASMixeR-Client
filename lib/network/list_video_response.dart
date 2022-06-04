import 'package:asmixer/data/entities/video.dart';

class ListVideoResponse {
  final List<Video> videos;

  ListVideoResponse({required this.videos});

  factory ListVideoResponse.fromJson(Map<String, dynamic> json) {
    List<Video> videos = [];
    json['items'].forEach((v) {
      videos.add(Video.fromJson(v));
    });
    return ListVideoResponse(
      videos: videos,
    );
  }
}
