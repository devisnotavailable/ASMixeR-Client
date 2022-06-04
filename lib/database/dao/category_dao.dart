import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/database/dao/base_dao.dart';
import 'package:floor/floor.dart';

@dao
abstract class CategoryDao extends BaseDao<Category> {
  @Query('SELECT * FROM Category')
  Stream<List<Category>> getCategoriesStream();

  @Query('SELECT * FROM Category WHERE isVideo = true')
  Stream<List<Category>> getVideoCategoriesStream();

  @Query('SELECT * FROM Category WHERE isAudio = true')
  Stream<List<Category>> getAudioCategoriesStream();

  @Query('SELECT * FROM Category')
  Future<List<Category>> getCategories();

  @Query('SELECT * FROM Category WHERE isAudio = true')
  Future<List<Category>> getAudioCategories();

  @Query('SELECT * FROM Category WHERE id = :id')
  Future<Category?> getCategoryByID(int id);
}
