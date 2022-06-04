import 'package:asmixer/data/entities/video.dart';
import 'package:asmixer/screens/blocs/channel_bloc.dart';
import 'package:asmixer/screens/events/channel_event.dart';
import 'package:asmixer/screens/states/channel_state.dart';
import 'package:asmixer/styles/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../service_locator.dart';
import 'bookmark_widget.dart';

class VideoDetailsWidget extends StatelessWidget {
  final Video video;

  const VideoDetailsWidget({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          getIt<ChannelBloc>()..add(LoadChannelEvent(video.snippet.channelID)),
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Builder(builder: (context) {
              return Row(
                children: [
                  Expanded(
                      child: Text(HtmlUnescape().convert(video.snippet.title),
                          style: const MediumTextStyle())),
                  TextButton(
                      onPressed: () {
                        context
                            .read<ChannelBloc>()
                            .add(VideoClickEvent(video.videoID));
                      },
                      child: const Icon(Icons.launch, size: 20))
                ],
              );
            }),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<ChannelBloc, ChannelState>(
                    builder: (context, channelState) => InkWell(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: CachedNetworkImage(
                                    height: 45,
                                    errorWidget: (
                                      BuildContext context,
                                      String url,
                                      dynamic error,
                                    ) =>
                                        Image.memory(kTransparentImage),
                                    placeholder: (context, a) {
                                      return Image.memory(kTransparentImage);
                                    },
                                    imageUrl: channelState.channel?.snippet
                                            .thumbnails.defaultThumbnail.url ??
                                        '',
                                  )),
                              const SizedBox(width: 10),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 200),
                                child: Text(
                                  video.snippet.channelTitle,
                                  style: const DescriptionTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            if (channelState.channel != null) {
                              context.read<ChannelBloc>().add(
                                  ChannelClickEvent(channelState.channel!.id));
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                duration: const Duration(seconds: 3),
                                content: Text(AppLocalizations.of(context)!
                                    .noChannelData),
                              ));
                            }
                          },
                        )),
                BookmarkWidget(video: video)
              ],
            )
          ],
        ),
      ),
    );
  }
}
