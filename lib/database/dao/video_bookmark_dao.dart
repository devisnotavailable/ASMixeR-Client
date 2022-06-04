import 'package:asmixer/data/entities/video_bookmark.dart';
import 'package:asmixer/database/dao/base_dao.dart';
import 'package:floor/floor.dart';

@dao
abstract class VideoBookmarkDao extends BaseDao<VideoBookmark> {
  @Query("SELECT * FROM VideoBookmark")
  Future<List<VideoBookmark>?> getBookmarks();

  @Query("SELECT * FROM VideoBookmark WHERE videoID = :videoID")
  Stream<VideoBookmark?> getBookmarkByIDStream(String videoID);
}
