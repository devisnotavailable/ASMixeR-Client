import 'package:asmixer/network/channel_response.dart';
import 'package:asmixer/network/list_video_response.dart';
import 'package:asmixer/network/network_handler.dart';
import 'package:asmixer/network/search_video_response.dart';

import '../constants.dart';

class YoutubeRepository {
  final NetworkHandler _networkHandler;
  final String baseUrl = "https://youtube.googleapis.com/youtube/v3";

  YoutubeRepository(this._networkHandler);

  Future<SearchVideoResponse> searchVideos(
      {int maxResults = 50,
      String pageToken = "",
      required String searchQuery,
      String locale = ""}) async {
    final response = await _networkHandler.get(
        "$baseUrl/search?part=snippet&maxResults=$maxResults&q=$searchQuery&type=video&pageToken=$pageToken&key=$youtubeApiKey&relevanceLanguage=$locale");
    return SearchVideoResponse.fromJson(response);
  }

  Future<ListVideoResponse> fetchVideos(
      {required List<String> videoIDs}) async {
    final response = await _networkHandler.get(
        "$baseUrl/videos?part=snippet&id=${videoIDs.join(',')}&key=$youtubeApiKey");
    return ListVideoResponse.fromJson(response);
  }

  Future<ChannelResponse> fetchChannel(
      {int maxResults = 50, required String channelID}) async {
    final response = await _networkHandler
        .get("$baseUrl/channels?part=snippet&id=$channelID&key=$youtubeApiKey");
    return ChannelResponse.fromJson(response);
  }
}
