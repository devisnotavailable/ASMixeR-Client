import 'package:asmixer/network/channel_response.dart';
import 'package:asmixer/network/youtube_repository.dart';
import 'package:asmixer/screens/events/channel_event.dart';
import 'package:asmixer/screens/states/channel_state.dart';
import 'package:bloc/bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ChannelBloc extends Bloc<ChannelEvent, ChannelState> {
  final YoutubeRepository youtubeRepository;

  ChannelBloc(ChannelState initialState, this.youtubeRepository)
      : super(initialState) {
    on<LoadChannelEvent>(_onLoadChannelEvent);
    on<ChannelClickEvent>(_onChannelClick);
    on<VideoClickEvent>(_onVideoClick);
  }

  _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  _onLoadChannelEvent(LoadChannelEvent event, Emitter emit) async {
    try {
      ChannelResponse channelResponse =
          await youtubeRepository.fetchChannel(channelID: event.channelID);
      emit(ChannelState(channelResponse.channels.first));
    } catch (e) {
      emit(ChannelState(
          null)); //don't really care about reasons why this failed, we won't display anything in this case
    }
  }

  _onChannelClick(ChannelClickEvent event, Emitter emit) {
    if (event.channelID.isNotEmpty) {
      _launchUrl("https://www.youtube.com/channel/${event.channelID}");
    }
  }

  _onVideoClick(VideoClickEvent event, Emitter emit) {
    if (event.videoID.isNotEmpty) {
      _launchUrl("https://www.youtube.com/watch?v=${event.videoID}");
    }
  }
}
