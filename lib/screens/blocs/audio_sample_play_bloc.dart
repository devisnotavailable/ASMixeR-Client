import 'package:asmixer/database/database.dart';
import 'package:asmixer/screens/events/audio_sample_play_event.dart';
import 'package:asmixer/screens/states/audio_sample_play_state.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';

class AudioSamplePlayBloc
    extends Bloc<AudioSamplePlayEvent, AudioSamplePlayState> {
  final _player = AudioPlayer();
  AppDatabase appDatabase;

  AudioSamplePlayBloc(AudioSamplePlayState initialState,
      {required this.appDatabase})
      : super(initialState) {
    _listenToPlaybackEvents();
    on<PlaybackChangeAudioSampleEvent>(_onPlaybackChanged);
    on<AudioCompletedEvent>(_onAudioCompletedEvent);
  }

  _onPlaybackChanged(PlaybackChangeAudioSampleEvent event, Emitter emit) {
    if (event.idSample == state.idSample) {
      if (!state.playing) {
        _startPlaying(event.idSample);
      } else {
        _player.stop();
      }
      emit(AudioSamplePlayState(!state.playing, event.idSample));
    } else {
      if (state.playing) {
        _player.stop();
      }
      _startPlaying(event.idSample);
      emit(AudioSamplePlayState(true, event.idSample));
    }
  }

  _startPlaying(idSample) async {
    var audioSample = await appDatabase.audioSampleDao.getByID(idSample);
    _player.setFilePath(audioSample!.path);
    _player.play();
  }

  _onAudioCompletedEvent(AudioCompletedEvent event, Emitter emit) {
    emit(AudioSamplePlayState(false, state.idSample));
  }

  _listenToPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      if (event.processingState == ProcessingState.completed) {
        add(AudioCompletedEvent());
      }
    });
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
