import 'package:asmixer/data/entities/audio_sample_to_category.dart';
import 'package:asmixer/database/dao/base_dao.dart';
import 'package:floor/floor.dart';

@dao
abstract class AudioToCategoryDao extends BaseDao<AudioSampleToCategory> {
  @Query('SELECT * FROM AudioSampleToCategory WHERE categoryID = :categoryID')
  Future<List<AudioSampleToCategory>?> getByCategory(int categoryID);

  @Query('SELECT * FROM AudioSampleToCategory WHERE id = :id')
  Future<AudioSampleToCategory?> getByID(int id);

  @Query('SELECT * FROM AudioSampleToCategory')
  Future<List<AudioSampleToCategory>?> getAll();
}
