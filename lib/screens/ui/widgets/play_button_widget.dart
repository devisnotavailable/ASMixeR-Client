import 'package:asmixer/screens/blocs/audio_player_bloc.dart';
import 'package:asmixer/screens/blocs/audio_transform_bloc.dart';
import 'package:asmixer/screens/blocs/current_profile_bloc.dart';
import 'package:asmixer/screens/blocs/init_bloc.dart';
import 'package:asmixer/screens/events/audio_player_event.dart';
import 'package:asmixer/screens/events/audio_transform_event.dart';
import 'package:asmixer/screens/states/audio_player_state.dart';
import 'package:asmixer/screens/states/audio_transform_state.dart';
import 'package:asmixer/screens/states/init_state.dart';
import 'package:asmixer/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayButtonWidget extends StatefulWidget {
  const PlayButtonWidget({Key? key}) : super(key: key);

  @override
  State<PlayButtonWidget> createState() => _PlayButtonWidgetState();
}

class _PlayButtonWidgetState extends State<PlayButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    super.initState();
  }

  void _getPlayerListener(AudioPlayerState state) {
    if (state.mode == PlayerMode.AUDIO_CHANGED) {
      context.read<AudioTransformBloc>().add(CreateNewAudioEvent());
    } else if (state.mode == PlayerMode.PLAYING) {
      _controller.forward();
    } else if (state.mode == PlayerMode.PAUSED) {
      _controller.reverse();
    }
  }

  void _getTransformListener(AudioTransformState transformState, playerState) {
    if (transformState is WorkingState && playerState.mode == PlayerMode.INIT) {
      _controller.forward();
    }
  }

  ButtonStyle _getMixButtonStyle({int size = 0}) {
    return ButtonStyle(
      elevation: MaterialStateProperty.resolveWith<double>(
          (Set<MaterialState> states) {
        if (states.contains(MaterialState.pressed) ||
            states.contains(MaterialState.disabled)) {
          return 0.0;
        }
        return 5;
      }),
      backgroundColor:
          MaterialStateProperty.all<Color>(Theme.of(context).primaryColorLight),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      )),
      fixedSize:
          size != 0 ? MaterialStateProperty.all(const Size.square(200)) : null,
      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      overlayColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return Colors.blue.withOpacity(0.04);
          }
          if (states.contains(MaterialState.focused) ||
              states.contains(MaterialState.pressed)) {
            return Colors.blue.withOpacity(0.12);
          }
          return null; // Defer to the widget's default.
        },
      ),
    );
  }

  bool _isDisabled(AudioPlayerState playerState, transformState,
      InitBlocState initBlockState) {
    return (playerState.mode == PlayerMode.INIT &&
            transformState is WorkingState) ||
        playerState.mode == PlayerMode.AUDIO_CHANGED ||
        initBlockState.initState != InitState.COMPLETED;
  }

  _getOnMixClick(AudioPlayerState playerState, transformState,
      InitBlocState initBlockState) {
    //returning null disables the button (sets button state to disabled)
    if (_isDisabled(playerState, transformState, initBlockState)) {
      return null;
    } else {
      return () {
        if (playerState.mode == PlayerMode.INIT) {
          context.read<AudioTransformBloc>().add(CreateNewAudioEvent(
              context.read<CurrentProfileBloc>().state.selectedProfile));
        } else {
          if (playerState.mode == PlayerMode.PLAYING) {
            context.read<AudioPlayerBloc>().add(PauseEvent());
          } else {
            context.read<AudioPlayerBloc>().add(PlayEvent());
          }
        }
      };
    }
  }

  _getOnRemixClick(playerState, transformState) {
    if (playerState.mode == PlayerMode.INIT) {
      return null;
    } else {
      return () {
        context.read<AudioPlayerBloc>().add(ResetPlayerEvent());
        context.read<AudioTransformBloc>().add(CreateNewAudioEvent(
            context.read<CurrentProfileBloc>().state.selectedProfile));
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InitBloc, InitBlocState>(
      builder: (BuildContext context, initBlockState) {
        return BlocConsumer<AudioPlayerBloc, AudioPlayerState>(
            listener: (context, state) => _getPlayerListener(state),
            builder: (context, playerState) {
              return BlocConsumer<AudioTransformBloc, AudioTransformState>(
                  listener: (context, state) =>
                      _getTransformListener(state, playerState),
                  builder: (BuildContext context, transformState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            style: _getMixButtonStyle(size: 200),
                            onPressed: _getOnMixClick(
                                playerState, transformState, initBlockState),
                            child: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: _controller,
                                size: 150,
                                color: Colors.blue)),
                        const SizedBox(height: 20),
                        AnimatedOpacity(
                            opacity:
                                playerState.mode != PlayerMode.INIT ? 1.0 : 0.0,
                            duration: const Duration(seconds: 2),
                            child: ElevatedButton(
                                style: _getMixButtonStyle(),
                                onPressed: _getOnRemixClick(
                                    playerState, transformState),
                                child: const Icon(Icons.repeat))),
                      ],
                    );
                  });
            });
      },
    );
  }
}
