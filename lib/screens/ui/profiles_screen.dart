import 'package:asmixer/data/entities/profile.dart';
import 'package:asmixer/screens/blocs/current_profile_bloc.dart';
import 'package:asmixer/screens/blocs/fab_bloc.dart';
import 'package:asmixer/screens/blocs/profiles_bloc.dart';
import 'package:asmixer/screens/events/current_profile_event.dart';
import 'package:asmixer/screens/events/fab_event.dart';
import 'package:asmixer/screens/events/profile_categories_event.dart';
import 'package:asmixer/screens/events/profiles_event.dart';
import 'package:asmixer/screens/states/current_profile_state.dart';
import 'package:asmixer/screens/states/fab_state.dart';
import 'package:asmixer/screens/states/profile_categories_state.dart';
import 'package:asmixer/screens/states/profiles_state.dart';
import 'package:asmixer/styles/styles.dart';
import 'package:asmixer/theme/themes.dart';
import 'package:asmixer/utils/localization_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../service_locator.dart';
import '../blocs/profile_categories_bloc.dart';

_toCreateProfileScreen(BuildContext context) {
  Navigator.pushNamed(context, '/profiles/create_profile');
}

const gridCount = 2;
const double fabOffset = 50;

bool _shouldShowFab(double pixels, double maxScrollExtent) {
  return pixels < maxScrollExtent - fabOffset;
}

class ProfilesScreen extends StatelessWidget {
  const ProfilesScreen({Key? key}) : super(key: key);

  _showUndoRemoveSnackBar(BuildContext context, state) {
    if (state is ProfileRemovedState) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 3),
            content: Text(AppLocalizations.of(context)!.profileRemoved),
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.undo,
              onPressed: () {
                context.read<ProfilesBloc>().add(UndoRemoveProfile(
                    state.removedProfile, state.removedCategories));
              },
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
            value: getIt<ProfilesBloc>()..add(LoadProfilesEvent())),
        BlocProvider(create: (BuildContext context) => getIt<FabBloc>()),
      ],
      child: BlocListener<ProfilesBloc, ProfilesState>(
        listener: _showUndoRemoveSnackBar,
        child: Scaffold(body: Builder(builder: (context) {
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              context.read<FabBloc>().add(ShowFabEvent(_shouldShowFab(
                  scrollInfo.metrics.pixels,
                  scrollInfo.metrics.maxScrollExtent)));
              return true;
            },
            child: const ProfilesBody(),
          );
        }), floatingActionButton: BlocBuilder<FabBloc, FabState>(
            builder: (BuildContext context, FabState fabState) {
          return AnimatedSlide(
            duration: const Duration(milliseconds: 300),
            offset: fabState.showFab ? Offset.zero : const Offset(0, 2),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: fabState.showFab ? 1 : 0,
              child: FloatingActionButton(
                onPressed: () => _toCreateProfileScreen(context),
                tooltip: AppLocalizations.of(context)!.newProfile,
                child: const Icon(Icons.add),
              ),
            ),
          );
        })),
      ),
    );
  }
}

class ProfilesBody extends StatefulWidget {
  const ProfilesBody({Key? key}) : super(key: key);

  @override
  State<ProfilesBody> createState() => _ProfilesBodyState();
}

class _ProfilesBodyState extends State<ProfilesBody> {
  final ScrollController _scrollController = ScrollController();

  _showFabOnRebuild(BuildContext context) {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      context.read<FabBloc>().add(ShowFabEvent(_shouldShowFab(
          _scrollController.position.pixels,
          _scrollController.position.maxScrollExtent)));
    });
  }

  _addProfileButton(profilesState) {
    if (profilesState.profilesList.isNotEmpty) {
      Profile profileAdd = const Profile(name: "none", id: -1);
      if (!profilesState.profilesList.contains(profileAdd)) {
        profilesState.profilesList.add(profileAdd);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfilesBloc, ProfilesState>(
        builder: (BuildContext context, ProfilesState profilesState) {
      if (profilesState.profilesList.isNotEmpty) {
        _showFabOnRebuild(context);
        _addProfileButton(profilesState);
        return SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              margin: const EdgeInsets.all(15),
              child: Text(AppLocalizations.of(context)!.profilesScreenTitle,
                  style: const TitleTextStyle())),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: GridView.count(
                crossAxisCount: gridCount,
                // childAspectRatio: 0.9,
                controller: _scrollController,
                children:
                    List.generate(profilesState.profilesList.length, (index) {
                  return index != profilesState.profilesList.length - 1
                      ? ProfileCell(
                          index: index,
                          profilesState: profilesState,
                        )
                      : const AddProfileWidget();
                })),
          ))
        ]));
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}

class ProfileCell extends StatelessWidget {
  const ProfileCell(
      {Key? key, required this.index, required this.profilesState})
      : super(key: key);

  final int index;
  final ProfilesState profilesState;

  @override
  Widget build(BuildContext context) {
    Profile profile = profilesState.profilesList[index];
    return MultiBlocProvider(
        //if not set will use bloc from list index
        key: ValueKey(profile),
        providers: [
          BlocProvider(
              create: (BuildContext context) => getIt<ProfileCategoriesBloc>()
                ..add(
                    LoadCategoriesEvent(profilesState.profilesList[index].id!)))
        ],
        child: BlocBuilder<CurrentProfileBloc, CurrentProfileState>(
          builder:
              (BuildContext context, CurrentProfileState currentProfileState) {
            return AnimatedContainer(
              margin: const EdgeInsets.all(5),
              curve: Curves.fastOutSlowIn,
              decoration: DefaultItemDecoration(
                  context: context,
                  selected:
                      currentProfileState.selectedProfile?.id == profile.id),
              duration: const Duration(milliseconds: 500),
              child: InkWell(
                  borderRadius: BorderRadius.circular(defaultBorderRadius),
                  onTap: () => profilesState.editActiveID == profile.id
                      ? context
                          .read<ProfilesBloc>()
                          .add(EditProfileModeEvent(-1))
                      : context
                          .read<CurrentProfileBloc>()
                          .add(SelectNewProfileEvent(profile)),
                  onLongPress: () => context
                      .read<ProfilesBloc>()
                      .add(EditProfileModeEvent(profile.id!)),
                  child: Stack(
                    children: [
                      Container(
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.only(right: 5),
                          child: TextButton(
                              onPressed: () => profilesState.editActiveID ==
                                      profile.id
                                  ? context
                                      .read<ProfilesBloc>()
                                      .add(EditProfileModeEvent(-1))
                                  : context
                                      .read<ProfilesBloc>()
                                      .add(EditProfileModeEvent(profile.id!)),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15))),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size.square(25))),
                              child: const Icon(Icons.more_vert,
                                  color: Colors.grey))),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 10),
                            Text(profile.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: const MediumTextStyle(),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 10),
                            BlocBuilder<ProfileCategoriesBloc,
                                    ProfileCategoriesState>(
                                builder:
                                    (BuildContext context, categoriesState) {
                              return SizedBox(
                                  height: 65,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return ScaleTransition(
                                          scale: animation, child: child);
                                    },
                                    child: profilesState.editActiveID ==
                                            profile.id
                                        ? EditWidget(
                                            profile: profile,
                                            profileList:
                                                profilesState.profilesList,
                                            currentProfileState:
                                                currentProfileState,
                                            index: index)
                                        : CategoriesTextWidget(
                                            categoriesState: categoriesState),
                                  ));
                            })
                          ],
                        ),
                      )
                    ],
                  )),
            );
          },
        ));
  }
}

class CategoriesTextWidget extends StatelessWidget {
  const CategoriesTextWidget({Key? key, required this.categoriesState})
      : super(key: key);

  final showCategoriesNum = 3;
  final ProfileCategoriesState categoriesState;

  @override
  Widget build(BuildContext context) {
    LocalizationUtil locUtil = getIt<LocalizationUtil>();
    String categoriesText = '';
    for (int i = 0;
        i < showCategoriesNum && i < categoriesState.categoryList.length;
        i++) {
      categoriesText +=
          "${categoriesState.categoryList[i].getNameForLocale(locUtil.isRussian(context))}\n";
    }
    if (categoriesState.categoryList.length > showCategoriesNum) {
      categoriesText +=
          "+ ${categoriesState.categoryList.length - showCategoriesNum} more";
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Text(categoriesText,
          key: ValueKey<String>(categoriesText),
          style: const DescriptionTextStyle(),
          textAlign: TextAlign.center),
    );
  }
}

class EditWidget extends StatelessWidget {
  const EditWidget(
      {Key? key,
      required this.profile,
      required this.profileList,
      required this.currentProfileState,
      required this.index})
      : super(key: key);

  final Profile profile;
  final List<Profile> profileList;
  final CurrentProfileState currentProfileState;
  final int index;

  ButtonStyle _getButtonStyle(BuildContext context) {
    return ButtonStyle(
      minimumSize: MaterialStateProperty.all(const Size.square(50)),
      backgroundColor:
          MaterialStateProperty.all<Color>(Theme.of(context).primaryColorLight),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: currentProfileState.selectedProfile?.id == profile.id
              ? Colors.lightBlue.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          profileList.length > 2
              ? TextButton(
                  style: _getButtonStyle(context),
                  onPressed: () {
                    var categories = context
                        .read<ProfileCategoriesBloc>()
                        .state
                        .categoryList;

                    //if we are deleting active profile
                    if (currentProfileState.selectedProfile?.id == profile.id) {
                      context.read<CurrentProfileBloc>().add(
                          SelectNewProfileEvent(profileList.first == profile
                              ? profileList[index + 1]
                              : profileList[index - 1]));
                    }

                    context
                        .read<ProfilesBloc>()
                        .add(RemoveProfileEvent(profile, categories));
                  },
                  child: const Icon(Icons.delete, color: Colors.grey))
              : Container(),
          const SizedBox(width: 5),
          TextButton(
              style: _getButtonStyle(context),
              onPressed: () {
                Navigator.pushNamed(context, '/profiles/create_profile',
                    arguments: profile);
              },
              child: const Icon(Icons.edit, color: Colors.grey)),
        ],
      ),
    );
  }
}

class AddProfileWidget extends StatelessWidget {
  const AddProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: DefaultItemDecoration(
          context: context, backgroundColor: Colors.white24),
      child: InkWell(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        onTap: () => _toCreateProfileScreen(context),
        child: Padding(
          padding: const EdgeInsets.all(defaultPadding / 4),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.add_rounded,
                    size: 100, color: Colors.grey.withOpacity(0.5))
              ]),
        ),
      ),
    );
  }
}
