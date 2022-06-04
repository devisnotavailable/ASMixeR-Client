import 'package:asmixer/data/entities/video.dart';
import 'package:asmixer/network/api_response.dart';
import 'package:asmixer/screens/blocs/discover_bloc.dart';
import 'package:asmixer/screens/events/discover_event.dart';
import 'package:asmixer/screens/states/discover_state.dart';
import 'package:asmixer/screens/ui/widgets/video_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../service_locator.dart';
import '../../utils/localization_util.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final PagingController<String, Video> _pagingController =
      PagingController(firstPageKey: "");

  late final DiscoverBloc discoverBloc;
  late final LocalizationUtil localizationUtil;

  @override
  void initState() {
    localizationUtil = getIt();
    discoverBloc = getIt<DiscoverBloc>();
    discoverBloc.add(DiscoverInitEvent());
    _pagingController.addPageRequestListener((pageKey) {
      discoverBloc.add(DiscoverOnMoreVideos(
          pageKey, _getSearchLocale(), localizationUtil.isRussian(context)));
    });
    super.initState();
  }

  String _getSearchLocale() => Localizations.localeOf(context).languageCode;

  _discoverListener(BuildContext context, DiscoverState state) {
    if (state is CategoriesReadyState) {
      //check if videoList is empty to avoid loading more videos on category updates
      //let's retain videos that we got before the update and get new ones from updated category
      if (state.videoList.isEmpty) {
        context.read<DiscoverBloc>().add(DiscoverOnMoreVideos(
            '', _getSearchLocale(), localizationUtil.isRussian(context)));
      }
    } else if (state is CategoryChangedState) {
      _pagingController.refresh();
    } else {
      var videoResponse = state.videoResponse?.data;
      if (state.videoResponse?.status == Status.COMPLETED) {
        final isLastPage = videoResponse.nextPageToken.isEmpty;
        if (isLastPage) {
          _pagingController.appendLastPage(state.videoList);
        } else {
          _pagingController.appendPage(
              state.videoList, videoResponse.nextPageToken);
        }
      } else if (state.videoResponse?.status == Status.ERROR) {
        _pagingController.error = state.videoResponse?.code;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: discoverBloc,
      child: BlocBuilder<DiscoverBloc, DiscoverState>(
          builder: (context, discoverState) {
        return BlocListener<DiscoverBloc, DiscoverState>(
          listener: _discoverListener,
          child: Scaffold(
              body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 50,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: discoverState.categoryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ChoiceChip(
                          selectedColor: Colors.lightBlue.withOpacity(0.3),
                          label: Text(discoverState.categoryList[index]
                              .getNameForLocale(
                                  localizationUtil.isRussian(context))),
                          selected: index == discoverState.selectedChipIndex,
                          //TODO: check what happens when selected category is deleted during the update
                          onSelected: (bool selected) {
                            context
                                .read<DiscoverBloc>()
                                .add(DiscoverCategorySelectedEvent(index));
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 5);
                      },
                    ),
                  ),
                ),
                _getVideoList(discoverState),
              ],
            ),
          )),
        );
      }),
    );
  }

  Widget _getVideoList(DiscoverState discoverState) {
    return Expanded(
      child: PagedListView<String, Video>.separated(
        shrinkWrap: true,
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Video>(
            itemBuilder: (context, item, index) {
          return VideoItemWidget(item, index);
        }),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 20);
        },
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
