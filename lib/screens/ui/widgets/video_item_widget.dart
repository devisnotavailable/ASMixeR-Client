import 'package:asmixer/data/entities/video.dart';
import 'package:asmixer/screens/ui/video_screen.dart';
import 'package:asmixer/screens/ui/widgets/video_details_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class VideoItemWidget extends StatefulWidget {
  final Video video;
  final int index;

  const VideoItemWidget(this.video, this.index, {Key? key}) : super(key: key);

  @override
  State<VideoItemWidget> createState() => _VideoItemWidgetState();
}

class _VideoItemWidgetState extends State<VideoItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/discover/video_details',
                arguments: VideoScreenArguments(widget.video));
          },
          child: CachedNetworkImage(
            height: MediaQuery.of(context).size.width * 0.75,
            //3:4 aspect ratio
            fit: BoxFit.cover,
            placeholder: (context, a) {
              return Image.memory(kTransparentImage);
            },
            errorWidget: (
              BuildContext context,
              String url,
              dynamic error,
            ) {
              return Image.asset("assets/images/youtube_placeholder.jpg",
                  fit: BoxFit.cover);
            },
            imageUrl: widget.video.snippet.thumbnails.highThumbnail.url,
          ),
        ),
        VideoDetailsWidget(video: widget.video)
      ],
    );
  }
}
