import 'package:asmixer/screens/blocs/audio_player_bloc.dart';
import 'package:asmixer/screens/blocs/audio_transform_bloc.dart';
import 'package:asmixer/screens/blocs/current_profile_bloc.dart';
import 'package:asmixer/screens/blocs/init_bloc.dart';
import 'package:asmixer/screens/blocs/remix_dialog_bloc.dart';
import 'package:asmixer/screens/blocs/video_bookmark_bloc.dart';
import 'package:asmixer/screens/events/init_event.dart';
import 'package:asmixer/screens/events/video_bookmark_event.dart';
import 'package:asmixer/screens/ui/audio_samples_screen.dart';
import 'package:asmixer/screens/ui/create_profile_screen.dart';
import 'package:asmixer/screens/ui/navigation_screen.dart';
import 'package:asmixer/screens/ui/profiles_screen.dart';
import 'package:asmixer/screens/ui/video_screen.dart';
import 'package:asmixer/service_locator.dart';
import 'package:asmixer/theme/theme_notifier.dart';
import 'package:asmixer/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: getIt<InitBloc>()..add(InitStartEvent())),
          BlocProvider.value(value: getIt<AudioPlayerBloc>()),
          BlocProvider.value(value: getIt<AudioTransformBloc>()),
          BlocProvider.value(value: getIt<CurrentProfileBloc>()),
          BlocProvider.value(value: getIt<RemixDialogBloc>()),
          BlocProvider(
            create: (BuildContext context) =>
                getIt<VideoBookmarkBloc>()..add(VideoBookmarkInitEvent()),
          )
        ],
        child: ChangeNotifierProvider<ThemeNotifier>(
          create: (context) => ThemeNotifier(),
          builder: (context, _) {
            final themeNotifier = Provider.of<ThemeNotifier>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: true,
              routes: <String, WidgetBuilder>{
                '/profiles': (BuildContext context) => const ProfilesScreen(),
                '/profiles/create_profile': (BuildContext context) =>
                    const CreateProfileScreen(),
                '/discover/video_details': (BuildContext context) =>
                    const VideoScreen(),
                '/audio_samples': (BuildContext context) =>
                    const AudioSamplesScreen(),
              },
              title: 'ASMixeR',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: lightTheme,
              themeMode: themeNotifier.getMode(),
              darkTheme: darkTheme,
              home: const NavigationScreen(),
            );
          },
        ),
      );
}
