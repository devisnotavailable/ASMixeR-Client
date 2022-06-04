import 'package:asmixer/data/entities/profile_to_category.dart';
import 'package:asmixer/database/dao/base_dao.dart';
import 'package:floor/floor.dart';

@dao
abstract class ProfileToCategoryDao extends BaseDao<ProfileToCategory> {
  @Query("SELECT * FROM ProfileToCategory WHERE profileID = :profileID")
  Future<List<ProfileToCategory>?> getCategoriesIDs(int profileID);

  @Query("SELECT * FROM ProfileToCategory WHERE profileID = :profileID")
  Stream<List<ProfileToCategory>?> getCategoriesIDsStream(int profileID);
}
