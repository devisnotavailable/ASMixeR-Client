import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/entities/category.dart';
import '../../network/api_response.dart';
import '../../service_locator.dart';
import '../../styles/styles.dart';
import '../../theme/themes.dart';
import '../../utils/localization_util.dart';
import '../blocs/audio_tab_bloc.dart';
import '../blocs/init_bloc.dart';
import '../events/library_event.dart';
import '../states/init_state.dart';
import '../states/library_state.dart';

class AudioTab extends StatelessWidget {
  const AudioTab({Key? key}) : super(key: key);

  _audioTabListener(BuildContext context, AudioTabState state) {
    if (state is CategoryUpdateFinishedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(state.apiResponse?.status == Status.ERROR
              ? AppLocalizations.of(context)!.updateFailed
              : state.hasUpdates!
                  ? AppLocalizations.of(context)!.updatesAvailable
                  : AppLocalizations.of(context)!.noUpdates),
        ),
      );
    } else if (state is DownloadFailedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 3),
          content: Text(AppLocalizations.of(context)!.downloadFailed),
        ),
      );
    }
  }

  _initListener(BuildContext context, InitBlocState state) {
    //load only after initialization completion
    if (state.initState == InitState.COMPLETED) {
      context.read<AudioTabBloc>().add(LoadCategoryEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        var audioTabBloc = getIt<AudioTabBloc>();
        if (context.read<InitBloc>().state.initState == InitState.COMPLETED) {
          audioTabBloc.add(
              LoadCategoryEvent()); //if init was already completed by the time the screen was created
        }
        return audioTabBloc;
      },
      child: BlocListener<InitBloc, InitBlocState>(
        listener: _initListener,
        child: BlocListener<AudioTabBloc, AudioTabState>(
          listener: _audioTabListener,
          child: BlocBuilder<AudioTabBloc, AudioTabState>(
            builder: (BuildContext context, AudioTabState libraryState) {
              return SafeArea(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed:
                          libraryState.apiResponse?.status == Status.LOADING ||
                                  libraryState.downloadingID != -1
                              ? null
                              : () => context
                                  .read<AudioTabBloc>()
                                  .add(UpdateCategoriesEvent()),
                      child:
                          Text(AppLocalizations.of(context)!.updateCategories)),
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.all(10),
                      childAspectRatio: 0.8,
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(libraryState.categoryList.length,
                          (index) {
                        return CategoryCard(
                          category: libraryState.categoryList[index],
                          downloadStatus: libraryState.downloadStatus,
                        );
                      }),
                    ),
                  ),
                ],
              ));
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {Key? key, required this.category, required this.downloadStatus})
      : super(key: key);

  final Category category;
  final DownloadStatus downloadStatus;

  @override
  Widget build(BuildContext context) {
    bool isRussian = getIt<LocalizationUtil>().isRussian(context);
    return Container(
      decoration: DefaultItemDecoration(context: context),
      child: InkWell(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        onTap: () =>
            Navigator.pushNamed(context, '/audio_samples', arguments: category),
        child: Stack(children: [
          Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(top: 10, right: 10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: category.toUpdateCount > 0
                    ? DownloadButton(
                  selectedToDownload:
                  context.read<AudioTabBloc>().state.downloadingID ==
                      category.id,
                  downloadProgress:
                  context.read<AudioTabBloc>().state.progress ?? 0,
                  onDownload: () => context
                      .read<AudioTabBloc>()
                      .add(DownloadSamplesEvent(category.id)),
                  onCancel: () => context
                      .read<AudioTabBloc>()
                      .add(CancelDownloadEvent()),
                  toDownloadCount: category.toUpdateCount,
                  downloadStatus: downloadStatus,
                  downloadingID:
                  context.read<AudioTabBloc>().state.downloadingID,
                )
                    : const SizedBox(),
              )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(category.getNameForLocale(isRussian),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: const MediumTextStyle(),
                        key: ValueKey<String>(
                            category.getNameForLocale(isRussian)),
                        textAlign: TextAlign.center),
                  ),
                ),
                const SizedBox(height: 10),
                Text(category.getDescriptionForLocale(isRussian),
                    style: const DescriptionTextStyle(),
                    maxLines: 6,
                    textAlign: TextAlign.center)
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

@immutable
class DownloadButton extends StatelessWidget {
  const DownloadButton(
      {Key? key,
      this.downloadProgress = 0.0,
      required this.onDownload,
      this.transitionDuration = const Duration(milliseconds: 500),
      required this.selectedToDownload,
      required this.onCancel,
      required this.toDownloadCount,
      required this.downloadStatus,
      required this.downloadingID})
      : super(key: key);

  final bool
      selectedToDownload; //need this cause we use one bloc to control all categories, might change this later
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final Duration transitionDuration;
  final int toDownloadCount;
  final DownloadStatus downloadStatus;
  final int downloadingID;

  bool get _isDownloading => downloadStatus == DownloadStatus.downloading;

  bool get _isFetching => downloadStatus == DownloadStatus.fetchingDownload;

  _onTap() {
    if (downloadingID == -1) {
      onDownload();
    } else if (selectedToDownload && _isDownloading) {
      onCancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Stack(
        children: [
          ButtonShapeWidget(
              transitionDuration: transitionDuration,
              isDownloading: selectedToDownload),
          Positioned.fill(
            child: AnimatedOpacity(
              duration: transitionDuration,
              opacity: selectedToDownload ? 1.0 : 0.0,
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                  ),
                  if (_isDownloading)
                    const Icon(
                      Icons.stop,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: DownloadCounter(
                toDownloadCount: toDownloadCount,
                downloading: selectedToDownload),
          )
        ],
      ),
    );
  }
}

@immutable
class ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    Key? key,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching,
  }) : super(key: key);

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress),
        duration: const Duration(milliseconds: 200),
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
                ? CupertinoColors.lightBackgroundGray
                : Colors.white.withOpacity(0),
            valueColor: AlwaysStoppedAnimation(isFetching
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeBlue),
            strokeWidth: 2,
            value: isFetching ? null : progress,
          );
        },
      ),
    );
  }
}

@immutable
class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    Key? key,
    required this.isDownloading,
    required this.transitionDuration,
  }) : super(key: key);

  final bool isDownloading;

  final Duration transitionDuration;

  @override
  Widget build(BuildContext context) {
    var shape = ShapeDecoration(
        shape: StadiumBorder(
            side: BorderSide(
      color: Colors.grey.withOpacity(0.2),
      width: 1,
    )));

    if (isDownloading) {
      shape = ShapeDecoration(
        shape: const CircleBorder(),
        color: Colors.white.withOpacity(0),
      );
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease,
      width: 70,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          duration: transitionDuration,
          opacity: isDownloading ? 0.0 : 1.0,
          curve: Curves.ease,
          child: const Icon(Icons.download),
        ),
      ),
    );
  }
}

class DownloadCounter extends StatelessWidget {
  const DownloadCounter(
      {Key? key, required this.toDownloadCount, required this.downloading})
      : super(key: key);

  final int toDownloadCount;
  final bool downloading;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: downloading ? 0.0 : 1.0,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8), shape: BoxShape.circle),
        width: 22,
        height: 22,
        child: Center(
            child: Text(
          toDownloadCount.toString(),
          style: const TextStyle(color: Colors.white70),
        )),
      ),
    );
  }
}
