import 'package:asmixer/data/entities/audio_sample.dart';
import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/screens/blocs/audio_sample_play_bloc.dart';
import 'package:asmixer/screens/blocs/audio_samples_bloc.dart';
import 'package:asmixer/screens/events/audio_sample_play_event.dart';
import 'package:asmixer/screens/events/audio_samples_event.dart';
import 'package:asmixer/screens/states/audio_sample_play_state.dart';
import 'package:asmixer/screens/states/audio_samples_state.dart';
import 'package:asmixer/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../service_locator.dart';
import '../blocs/audio_player_bloc.dart';
import '../events/audio_player_event.dart';
import '../states/audio_player_state.dart';

class AudioSamplesScreen extends StatelessWidget {
  const AudioSamplesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Category? _currentCategory =
        ModalRoute.of(context)!.settings.arguments as Category?;
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (BuildContext context) => getIt<AudioSamplesBloc>()
                ..add(AudioSamplesEvent(idCategory: _currentCategory!.id))),
          BlocProvider(
              create: (BuildContext context) => getIt<AudioSamplePlayBloc>()),
        ],
        child: BlocBuilder<AudioSamplesBloc, AudioSamplesState>(builder:
            (BuildContext context, AudioSamplesState audioSamplesState) {
          return Scaffold(
            appBar: AppBar(title: Text(_currentCategory!.name)),
            body: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: audioSamplesState.audioSampleList.length,
                        itemBuilder: (context, index) => _cardWidget(
                            context,
                            index,
                            audioSamplesState.audioSampleList,
                            _currentCategory.id)),
                  ),
                ]),
          );
        }));
  }

  _cardWidget(context, index, List<AudioSample> listSample, idCategory) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: DefaultItemDecoration(context: context),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PlayButton(sampleID: listSample[index].id!),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    listSample[index].name,
                    style: const LabelTextStyle(),
                  ),
                )
              ],
            )));
  }
}

class PlayButton extends StatefulWidget {
  const PlayButton({Key? key, required this.sampleID}) : super(key: key);

  final int sampleID;

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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioSamplePlayBloc, AudioSamplePlayState>(
        listener: (BuildContext context, AudioSamplePlayState playState) {
      playState.idSample == widget.sampleID && playState.playing
          ? _controller.forward()
          : _controller.reverse();
    }, builder: (BuildContext context, AudioSamplePlayState playState) {
      return TextButton(
          onPressed: () {
            if (context.read<AudioPlayerBloc>().state.mode ==
                PlayerMode.PLAYING) {
              context.read<AudioPlayerBloc>().add(PauseEvent());
            }
            context
                .read<AudioSamplePlayBloc>()
                .add(PlaybackChangeAudioSampleEvent(idSample: widget.sampleID));
          },
          child: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _controller,
              size: 60,
              color: Colors.blue));
    });
  }
}
