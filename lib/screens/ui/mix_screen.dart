import 'package:asmixer/screens/blocs/audio_player_bloc.dart';
import 'package:asmixer/screens/blocs/audio_transform_bloc.dart';
import 'package:asmixer/screens/blocs/current_profile_bloc.dart';
import 'package:asmixer/screens/blocs/remix_dialog_bloc.dart';
import 'package:asmixer/screens/events/audio_player_event.dart';
import 'package:asmixer/screens/states/audio_transform_state.dart';
import 'package:asmixer/screens/states/current_profile_state.dart';
import 'package:asmixer/screens/ui/dialogs/remix_bottom_sheet.dart';
import 'package:asmixer/screens/ui/widgets/current_profile_widget.dart';
import 'package:asmixer/screens/ui/widgets/play_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/init_bloc.dart';
import '../events/audio_transform_event.dart';
import '../events/current_profile_event.dart';
import '../states/init_state.dart';

class MixScreen extends StatefulWidget {
  const MixScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MixScreenState();
}

class _MixScreenState extends State<MixScreen> {
  _getInitListener(InitBlocState state) {
    if (state.initState == InitState.COMPLETED) {
      context.read<CurrentProfileBloc>().add(InitialProfileEvent());
    }
  }

  void _getTransformListener(
      BuildContext context,
      AudioTransformState transformState,
      CurrentProfileState currentProfileState) {
    if (transformState is AudioReadyState) {
      context.read<AudioPlayerBloc>().add(AddToPlaylistEvent(
          transformState.activeProfile.name,
          AppLocalizations.of(context)!.playerAlbumName,
          transformState.path));
    }
  }

  _currentProfileListener(profileState, RemixAction remixAction) {
    if (profileState is CurrentProfileChangedState) {
      if (remixAction == RemixAction.ASK) {
        pushProfileBottomSheet(context);
      } else if (remixAction == RemixAction.REMIX) {
        context.read<AudioPlayerBloc>().add(ResetPlayerEvent());
        context
            .read<AudioTransformBloc>()
            .add(CreateNewAudioEvent(profileState.selectedProfile));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitBloc, InitBlocState>(
      listener: (context, state) => _getInitListener(state),
      child: BlocListener<CurrentProfileBloc, CurrentProfileState>(
          listener: (context, profileState) {
            _currentProfileListener(profileState,
                context.read<RemixDialogBloc>().state.remixAction);
          },
          child: BlocListener<AudioTransformBloc, AudioTransformState>(
              listener: (context, state) => _getTransformListener(
                  context, state, context.read<CurrentProfileBloc>().state),
              child: BlocBuilder<CurrentProfileBloc, CurrentProfileState>(
                  builder: (BuildContext context,
                      CurrentProfileState currentProfileState) {
                return Scaffold(
                  body: Column(
                    children: [
                      SafeArea(
                        child: Container(
                          alignment: Alignment.topRight,
                          margin: const EdgeInsets.only(top: 20, right: 20),
                          child: AnimatedOpacity(
                            child: const CurrentProfileWidget(),
                            opacity: currentProfileState.selectedProfile != null
                                ? 0.3
                                : 0.0,
                            curve: Curves.easeOut,
                            duration: const Duration(seconds: 2),
                          ),
                        ),
                      ),
                      const Expanded(child: PlayButtonWidget()),
                    ],
                  ),
                );
              }))),
    );
  }
}
