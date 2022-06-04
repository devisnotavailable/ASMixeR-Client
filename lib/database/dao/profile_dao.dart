import 'package:asmixer/data/entities/profile.dart';
import 'package:asmixer/database/dao/base_dao.dart';
import 'package:floor/floor.dart';

@dao
abstract class ProfileDao extends BaseDao<Profile> {
  @Query("SELECT * FROM Profile WHERE id = :id")
  Future<Profile?> getProfileByID(int id);

  @Query("SELECT * FROM Profile")
  Stream<List<Profile>> getProfilesStream();
}
