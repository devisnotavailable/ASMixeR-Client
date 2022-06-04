import 'dart:io';

import 'package:asmixer/database/database.dart';
import 'package:asmixer/network/asmixer_repository.dart';
import 'package:asmixer/network/network_handler.dart';
import 'package:asmixer/network/youtube_repository.dart';
import 'package:asmixer/screens/blocs/audio_player_bloc.dart';
import 'package:asmixer/screens/blocs/audio_sample_play_bloc.dart';
import 'package:asmixer/screens/blocs/audio_samples_bloc.dart';
import 'package:asmixer/screens/blocs/audio_tab_bloc.dart';
import 'package:asmixer/screens/blocs/audio_transform_bloc.dart';
import 'package:asmixer/screens/blocs/category_play_bloc.dart';
import 'package:asmixer/screens/blocs/category_visibility_bloc.dart';
import 'package:asmixer/screens/blocs/channel_bloc.dart';
import 'package:asmixer/screens/blocs/create_profile_bloc.dart';
import 'package:asmixer/screens/blocs/current_profile_bloc.dart';
import 'package:asmixer/screens/blocs/discover_bloc.dart';
import 'package:asmixer/screens/blocs/fab_bloc.dart';
import 'package:asmixer/screens/blocs/init_bloc.dart';
import 'package:asmixer/screens/blocs/navigation_bloc.dart';
import 'package:asmixer/screens/blocs/profile_categories_bloc.dart';
import 'package:asmixer/screens/blocs/profiles_bloc.dart';
import 'package:asmixer/screens/blocs/remix_dialog_bloc.dart';
import 'package:asmixer/screens/blocs/video_bookmark_bloc.dart';
import 'package:asmixer/screens/states/audio_sample_play_state.dart';
import 'package:asmixer/screens/states/audio_samples_state.dart';
import 'package:asmixer/screens/states/category_play_state.dart';
import 'package:asmixer/screens/states/category_visibility_state.dart';
import 'package:asmixer/screens/states/channel_state.dart';
import 'package:asmixer/screens/states/create_profile_state.dart';
import 'package:asmixer/screens/states/current_profile_state.dart';
import 'package:asmixer/screens/states/discover_state.dart';
import 'package:asmixer/screens/states/fab_state.dart';
import 'package:asmixer/screens/states/init_state.dart';
import 'package:asmixer/screens/states/library_state.dart';
import 'package:asmixer/screens/states/navigation_state.dart';
import 'package:asmixer/screens/states/profile_categories_state.dart';
import 'package:asmixer/screens/states/profiles_state.dart';
import 'package:asmixer/screens/states/remix_dialog_state.dart';
import 'package:asmixer/screens/states/video_bookmark_state.dart';
import 'package:asmixer/screens/ui/library_screen.dart';
import 'package:asmixer/screens/ui/mix_screen.dart';
import 'package:asmixer/screens/ui/settings_screen.dart';
import 'package:asmixer/utils/localization_util.dart';
import 'package:asmixer/utils/shared_preferences_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'services/audio_handler.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<NetworkHandler>(NetworkHandler());
  getIt.registerSingleton<YoutubeRepository>(YoutubeRepository(getIt()));
  getIt.registerSingleton<MixerRepository>(MixerRepository(getIt()));
  getIt.registerSingleton<AppAudioHandler>(await initAudioHandler());
  getIt.registerSingleton<AppDatabase>(await initDatabase());
  getIt
      .registerSingleton<SharedPreferencesUtils>(await initSharedPreferences());
  getIt.registerSingleton<PackageInfo>(await PackageInfo.fromPlatform());
  getIt.registerSingleton<LocalizationUtil>(LocalizationUtil());
  getIt.registerSingleton<Directory>(await getApplicationDocumentsDirectory());
  getIt.registerSingleton<AudioTransformBloc>(
      AudioTransformBloc(directory: getIt(), appDatabase: getIt()));
  getIt.registerSingleton<AudioPlayerBloc>(AudioPlayerBloc(getIt()));
  getIt.registerSingleton<InitBloc>(InitBloc(const InitBlocState(),
      directory: getIt(),
      appDatabase: getIt(),
      sharedPreferencesUtils: getIt()));
  getIt.registerSingleton<NavigationBloc>(NavigationBloc(NavigationState(0, [
    const MixScreen(),
    Container(),
    const LibraryScreen(),
    const SettingsScreen()
  ])));
  getIt.registerSingleton<CurrentProfileBloc>(CurrentProfileBloc(
      const CurrentProfileState(),
      sharedPreferencesUtils: getIt(),
      profileDao: getIt<AppDatabase>().profileDao));
  getIt.registerSingleton<ProfilesBloc>(ProfilesBloc(ProfilesState(),
      profileDao: getIt<AppDatabase>().profileDao,
      sharedPreferencesUtils: getIt<SharedPreferencesUtils>(),
      profileToCategoryDao: getIt<AppDatabase>().profileToCategoryDao));
  getIt.registerFactory<AudioTabBloc>(() => AudioTabBloc(
      AudioTabState(categoryList: const []),
      appDatabase: getIt(),
      directory: getIt(),
      mixerRepository: getIt()));
  getIt.registerFactory<AudioSamplesBloc>(() => AudioSamplesBloc(
      AudioSamplesState(audioSampleList: const []),
      audioSampleDao: getIt<AppDatabase>().audioSampleDao,
      audioToCategoryDao: getIt<AppDatabase>().audioToCategoryDao));
  getIt.registerSingleton<RemixDialogBloc>(RemixDialogBloc(
      RemixDialogState(getIt<SharedPreferencesUtils>().getRemixAction()),
      getIt()));
  getIt.registerFactory<CreateProfileBloc>(() {
    return CreateProfileBloc(
        CreateProfileState(const [], const []),
        getIt<AppDatabase>().profileDao,
        getIt<AppDatabase>().categoryDao,
        getIt<AppDatabase>().profileToCategoryDao);
  });
  getIt.registerFactory<CategoryPlayBloc>(() => CategoryPlayBloc(
      CategoryPlayState(false, -1),
      directory: getIt(),
      appDatabase: getIt()));
  getIt.registerFactory<AudioSamplePlayBloc>(() => AudioSamplePlayBloc(
      AudioSamplePlayState(false, -1),
      appDatabase: getIt()));
  getIt.registerFactory<CategoryVisibilityBloc>(
      () => CategoryVisibilityBloc(CategoryVisibilityState(true, false)));
  getIt.registerSingleton(DiscoverBloc(
      DiscoverState(
          videoResponse: null,
          videoList: [],
          categoryList: [],
          selectedChipIndex: 0,
          useSearchLocale: getIt<SharedPreferencesUtils>().isUseSearchLocale()),
      getIt(),
      getIt<AppDatabase>().categoryDao,
      getIt(),
      getIt()));
  getIt.registerFactory<VideoBookmarkBloc>(() => VideoBookmarkBloc(
      VideoBookmarkState([], [], false),
      getIt<AppDatabase>().videoBookmarkDao,
      getIt()));
  getIt.registerFactory(() => ChannelBloc(ChannelState(null), getIt()));
  getIt.registerFactory(
      () => ProfileCategoriesBloc(ProfileCategoriesState([]), getIt()));
  getIt.registerFactory(() => FabBloc(FabState(false)));
}
