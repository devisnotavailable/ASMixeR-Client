import 'package:asmixer/data/entities/audio_sample.dart';
import 'package:asmixer/database/dao/base_dao.dart';
import 'package:floor/floor.dart';

@dao
abstract class AudioSampleDao extends BaseDao<AudioSample> {
  @Query('SELECT * FROM AudioSample WHERE id = :id')
  Future<AudioSample?> getByID(int id);

  @Query('SELECT * FROM AudioSample')
  Future<List<AudioSample>> getAudioSamples();
}
