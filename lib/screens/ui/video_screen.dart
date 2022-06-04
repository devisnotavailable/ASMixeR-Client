import 'package:asmixer/data/entities/video.dart';
import 'package:asmixer/screens/ui/widgets/video_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class VideoScreenArguments {
  final Video video;

  VideoScreenArguments(this.video);
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    VideoScreenArguments arguments =
        ModalRoute.of(context)!.settings.arguments as VideoScreenArguments;
    Video video = arguments.video;
    _controller = YoutubePlayerController(
        initialVideoId: video.videoID,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
        ));
    return YoutubePlayerBuilder(
        player: YoutubePlayer(controller: _controller),
        builder: (context, player) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  player,
                  VideoDetailsWidget(video: video),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(HtmlUnescape()
                              .convert(video.snippet.description))),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
