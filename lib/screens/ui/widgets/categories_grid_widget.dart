import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/screens/blocs/audio_player_bloc.dart';
import 'package:asmixer/screens/blocs/category_play_bloc.dart';
import 'package:asmixer/screens/blocs/create_profile_bloc.dart';
import 'package:asmixer/screens/events/audio_player_event.dart';
import 'package:asmixer/screens/events/audio_sample_play_event.dart';
import 'package:asmixer/screens/events/create_profile_event.dart';
import 'package:asmixer/screens/states/audio_player_state.dart';
import 'package:asmixer/screens/states/category_play_state.dart';
import 'package:asmixer/screens/states/create_profile_state.dart';
import 'package:asmixer/styles/styles.dart';
import 'package:asmixer/theme/themes.dart';
import 'package:asmixer/utils/localization_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service_locator.dart';

class CategoriesGridWidget extends StatelessWidget {
  const CategoriesGridWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProfileBloc, CreateProfileState>(
      builder: (BuildContext context, CreateProfileState createProfileState) {
        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 0.7,
          children: List.generate(
              createProfileState.categoryList.length,
              (index) => CategoryCell(
                  category: createProfileState.categoryList[index],
                  selected: createProfileState.selectedCategories
                      .contains(createProfileState.categoryList[index]))),
          physics:
              const NeverScrollableScrollPhysics(), //prevents scrolling of gridview
        );
      },
    );
  }
}

class CategoryCell extends StatelessWidget {
  const CategoryCell({Key? key, required this.category, required this.selected})
      : super(key: key);

  final Category category;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    bool isRussian = getIt<LocalizationUtil>().isRussian(context);
    return AnimatedContainer(
        margin: const EdgeInsets.all(3),
        decoration: DefaultItemDecoration(context: context, selected: selected),
        curve: Curves.fastOutSlowIn,
        duration: const Duration(milliseconds: 500),
        child: InkWell(
          borderRadius: BorderRadius.circular(defaultBorderRadius),
          onTap: () => context
              .read<CreateProfileBloc>()
              .add(SelectedCategoryChangedEvent(category)),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(category.getNameForLocale(isRussian),
                    style: const MediumTextStyle(),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                SizedBox(
                  height: 100,
                  child: Center(
                    child: Text(category.getDescriptionForLocale(isRussian),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: const DescriptionTextStyle(),
                        textAlign: TextAlign.center),
                  ),
                ),
                PlayButton(categoryID: category.id),
              ],
            ),
          ),
        ));
  }
}

class PlayButton extends StatefulWidget {
  const PlayButton({Key? key, required this.categoryID}) : super(key: key);

  final int categoryID;

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryPlayBloc, CategoryPlayState>(
        listener: (BuildContext context, CategoryPlayState playState) {
      playState.playing && playState.categoryID == widget.categoryID
          ? _controller.forward()
          : _controller.reverse();
    }, builder: (BuildContext context, CategoryPlayState playState) {
      return TextButton(
          onPressed: () {
            if (context.read<AudioPlayerBloc>().state.mode ==
                PlayerMode.PLAYING) {
              context.read<AudioPlayerBloc>().add(PauseEvent());
            }
            context
                .read<CategoryPlayBloc>()
                .add(PlaybackChangeEvent(widget.categoryID));
          },
          child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _controller,
              size: 40,
              color: Colors.blue));
    });
  }
}
