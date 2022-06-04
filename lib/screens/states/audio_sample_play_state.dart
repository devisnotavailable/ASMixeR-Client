import 'base_state.dart';

class AudioSamplePlayState extends BaseState {
  final bool playing;
  final int idSample;

  @override
  List<Object> get props => [playing, idSample];

  AudioSamplePlayState(this.playing, this.idSample);
}
