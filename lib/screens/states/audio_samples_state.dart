import 'package:asmixer/data/entities/audio_sample.dart';
import 'package:asmixer/screens/states/base_state.dart';

class AudioSamplesState extends BaseState {
  final List<AudioSample> audioSampleList;

  @override
  List<Object> get props => [audioSampleList];

  AudioSamplesState({required this.audioSampleList});
}
