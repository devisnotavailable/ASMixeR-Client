// required package imports
import 'dart:async';

import 'package:asmixer/data/entities/audio_sample.dart';
import 'package:asmixer/data/entities/audio_sample_to_category.dart';
import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/data/entities/profile.dart';
import 'package:asmixer/data/entities/profile_to_category.dart';
import 'package:asmixer/data/entities/video_bookmark.dart';
import 'package:asmixer/database/dao/audio_sample_dao.dart';
import 'package:asmixer/database/dao/auido_to_category_dao.dart';
import 'package:asmixer/database/dao/category_dao.dart';
import 'package:asmixer/database/dao/profile_dao.dart';
import 'package:asmixer/database/dao/profile_to_category_dao.dart';
import 'package:asmixer/database/dao/video_bookmark_dao.dart';
import 'package:asmixer/database/type_converters/preference_enum_converter.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

const String databaseName = "app_database.db";

Future<AppDatabase> initDatabase() async {
  return $FloorAppDatabase.databaseBuilder(databaseName).build();
}

@TypeConverters([PreferenceEnumConverter])
@Database(version: 1, entities: [
  Category,
  Profile,
  ProfileToCategory,
  AudioSample,
  AudioSampleToCategory,
  VideoBookmark
])
abstract class AppDatabase extends FloorDatabase {
  CategoryDao get categoryDao;

  ProfileDao get profileDao;

  ProfileToCategoryDao get profileToCategoryDao;

  AudioSampleDao get audioSampleDao;

  AudioToCategoryDao get audioToCategoryDao;

  VideoBookmarkDao get videoBookmarkDao;
}
