import 'package:asmixer/screens/ui/widgets/video_item_widget.dart';
import 'package:asmixer/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/video_bookmark_bloc.dart';
import '../states/video_bookmark_state.dart';

class VideoTab extends StatelessWidget {
  const VideoTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoBookmarkBloc, VideoBookmarkState>(
        builder: (BuildContext context, bookmarkState) {
      return AnimatedSwitcher(
        switchInCurve: Curves.easeInBack,
        duration: const Duration(milliseconds: 500),
        child: bookmarkState.videosLoaded
            ? bookmarkState.bookmarkIDs.isNotEmpty
                ? ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: bookmarkState.bookmarkedVideos.length,
                    itemBuilder: (context, index) {
                      return VideoItemWidget(
                          bookmarkState.bookmarkedVideos[index], index);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 20);
                    },
                  )
                : Center(
                    child: Text(
                    AppLocalizations.of(context)!.noBookmarks,
                    style: const UnimportantTextStyle(),
                  ))
            : const Center(child: CircularProgressIndicator()),
      );
    });
  }
}
