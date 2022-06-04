import 'package:asmixer/database/dao/audio_sample_dao.dart';
import 'package:asmixer/database/dao/auido_to_category_dao.dart';
import 'package:asmixer/screens/events/audio_samples_event.dart';
import 'package:asmixer/screens/states/audio_samples_state.dart';
import 'package:bloc/bloc.dart';

import '../../data/entities/audio_sample.dart';

class AudioSamplesBloc extends Bloc<AudioSamplesEvent, AudioSamplesState> {
  AudioSampleDao audioSampleDao;
  AudioToCategoryDao audioToCategoryDao;

  AudioSamplesBloc(AudioSamplesState initialState,
      {required this.audioSampleDao, required this.audioToCategoryDao})
      : super(initialState) {
    on<AudioSamplesEvent>(_onLoad);
  }

  _onLoad(AudioSamplesEvent event, Emitter emit) async {
    var listToCategory =
        await audioToCategoryDao.getByCategory(event.idCategory);
    List<AudioSample> listSample = [];
    for (var element in listToCategory!) {
      var audioSample = await audioSampleDao.getByID(element.audioSampleID);
      listSample.add(audioSample!);
    }
    emit(AudioSamplesState(audioSampleList: listSample));
  }
}
