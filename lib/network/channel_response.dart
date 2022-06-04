import 'package:asmixer/data/entities/channel.dart';

class ChannelResponse {
  final List<Channel> channels;

  ChannelResponse({required this.channels});

  factory ChannelResponse.fromJson(Map<String, dynamic> json) {
    List<Channel> channels = [];
    json['items'].forEach((v) {
      channels.add(Channel.fromJson(v));
    });
    return ChannelResponse(
      channels: channels,
    );
  }
}
