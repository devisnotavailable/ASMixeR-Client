import 'package:asmixer/data/entities/video.dart';
import 'package:asmixer/screens/blocs/video_bookmark_bloc.dart';
import 'package:asmixer/screens/events/video_bookmark_event.dart';
import 'package:asmixer/screens/states/video_bookmark_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookmarkWidget extends StatelessWidget {
  final Video video;

  const BookmarkWidget({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBookmarkBloc, VideoBookmarkState>(
      builder: (BuildContext context, bookmarkState) {
        return TextButton(
            onPressed: () {
              context
                  .read<VideoBookmarkBloc>()
                  .add(VideoBookmarkChangedEvent(video));
            },
            child: Icon(
              Icons.bookmark,
              color: bookmarkState.bookmarkIDs.contains(video.videoID)
                  ? Colors.blue
                  : Colors.grey,
            ));
      },
    );
  }
}
