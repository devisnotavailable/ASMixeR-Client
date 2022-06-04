import 'package:asmixer/data/entities/video.dart';

class SearchVideoResponse {
  final String nextPageToken;
  final PageInfo pageInfo;
  final List<Video> videos;

  SearchVideoResponse(
      {required this.nextPageToken,
      required this.pageInfo,
      required this.videos});

  factory SearchVideoResponse.fromJson(Map<String, dynamic> json) {
    List<Video> videos = [];
    json['items'].forEach((v) {
      videos.add(Video.fromJson(v));
    });
    return SearchVideoResponse(
      nextPageToken: json['nextPageToken'],
      pageInfo: PageInfo.fromJson(json['pageInfo']),
      videos: videos,
    );
  }
}

class PageInfo {
  final int totalResults;
  final int resultsPerPage;

  PageInfo({required this.totalResults, required this.resultsPerPage});

  factory PageInfo.fromJson(Map<String, dynamic> json) {
    return PageInfo(
      totalResults: json['totalResults'],
      resultsPerPage: json['resultsPerPage'],
    );
  }
}
