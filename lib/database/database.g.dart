// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CategoryDao? _categoryDaoInstance;

  ProfileDao? _profileDaoInstance;

  ProfileToCategoryDao? _profileToCategoryDaoInstance;

  AudioSampleDao? _audioSampleDaoInstance;

  AudioToCategoryDao? _audioToCategoryDaoInstance;

  VideoBookmarkDao? _videoBookmarkDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Category` (`id` INTEGER NOT NULL, `name` TEXT NOT NULL, `nameRu` TEXT NOT NULL, `description` TEXT NOT NULL, `descriptionRu` TEXT NOT NULL, `serverCount` INTEGER NOT NULL, `isVideo` INTEGER NOT NULL, `isAudio` INTEGER NOT NULL, `toUpdateCount` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Profile` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `nameRu` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProfileToCategory` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `profileID` INTEGER NOT NULL, `categoryID` INTEGER NOT NULL, FOREIGN KEY (`profileID`) REFERENCES `Profile` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`categoryID`) REFERENCES `Category` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AudioSample` (`id` INTEGER, `name` TEXT NOT NULL, `path` TEXT NOT NULL, `lastEditDate` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AudioSampleToCategory` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `audioSampleID` INTEGER NOT NULL, `categoryID` INTEGER NOT NULL, FOREIGN KEY (`categoryID`) REFERENCES `Category` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE, FOREIGN KEY (`audioSampleID`) REFERENCES `AudioSample` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `VideoBookmark` (`videoID` TEXT NOT NULL, PRIMARY KEY (`videoID`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  ProfileDao get profileDao {
    return _profileDaoInstance ??= _$ProfileDao(database, changeListener);
  }

  @override
  ProfileToCategoryDao get profileToCategoryDao {
    return _profileToCategoryDaoInstance ??=
        _$ProfileToCategoryDao(database, changeListener);
  }

  @override
  AudioSampleDao get audioSampleDao {
    return _audioSampleDaoInstance ??=
        _$AudioSampleDao(database, changeListener);
  }

  @override
  AudioToCategoryDao get audioToCategoryDao {
    return _audioToCategoryDaoInstance ??=
        _$AudioToCategoryDao(database, changeListener);
  }

  @override
  VideoBookmarkDao get videoBookmarkDao {
    return _videoBookmarkDaoInstance ??=
        _$VideoBookmarkDao(database, changeListener);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _categoryInsertionAdapter = InsertionAdapter(
            database,
            'Category',
            (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'nameRu': item.nameRu,
                  'description': item.description,
                  'descriptionRu': item.descriptionRu,
                  'serverCount': item.serverCount,
                  'isVideo': item.isVideo ? 1 : 0,
                  'isAudio': item.isAudio ? 1 : 0,
                  'toUpdateCount': item.toUpdateCount
                },
            changeListener),
        _categoryUpdateAdapter = UpdateAdapter(
            database,
            'Category',
            ['id'],
                (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'nameRu': item.nameRu,
                  'description': item.description,
                  'descriptionRu': item.descriptionRu,
                  'serverCount': item.serverCount,
                  'isVideo': item.isVideo ? 1 : 0,
                  'isAudio': item.isAudio ? 1 : 0,
                  'toUpdateCount': item.toUpdateCount
                },
            changeListener),
        _categoryDeletionAdapter = DeletionAdapter(
            database,
            'Category',
            ['id'],
                (Category item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'nameRu': item.nameRu,
                  'description': item.description,
                  'descriptionRu': item.descriptionRu,
                  'serverCount': item.serverCount,
                  'isVideo': item.isVideo ? 1 : 0,
                  'isAudio': item.isAudio ? 1 : 0,
                  'toUpdateCount': item.toUpdateCount
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Category> _categoryInsertionAdapter;

  final UpdateAdapter<Category> _categoryUpdateAdapter;

  final DeletionAdapter<Category> _categoryDeletionAdapter;

  @override
  Stream<List<Category>> getCategoriesStream() {
    return _queryAdapter.queryListStream('SELECT * FROM Category',
        mapper: (Map<String, Object?> row) => Category(
            description: row['description'] as String,
            descriptionRu: row['descriptionRu'] as String,
            id: row['id'] as int,
            name: row['name'] as String,
            nameRu: row['nameRu'] as String,
            serverCount: row['serverCount'] as int,
            isVideo: (row['isVideo'] as int) != 0,
            isAudio: (row['isAudio'] as int) != 0,
            toUpdateCount: row['toUpdateCount'] as int),
        queryableName: 'Category',
        isView: false);
  }

  @override
  Stream<List<Category>> getVideoCategoriesStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Category WHERE isVideo = true',
        mapper: (Map<String, Object?> row) => Category(
            description: row['description'] as String,
            descriptionRu: row['descriptionRu'] as String,
            id: row['id'] as int,
            name: row['name'] as String,
            nameRu: row['nameRu'] as String,
            serverCount: row['serverCount'] as int,
            isVideo: (row['isVideo'] as int) != 0,
            isAudio: (row['isAudio'] as int) != 0,
            toUpdateCount: row['toUpdateCount'] as int),
        queryableName: 'Category',
        isView: false);
  }

  @override
  Stream<List<Category>> getAudioCategoriesStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Category WHERE isAudio = true',
        mapper: (Map<String, Object?> row) => Category(
            description: row['description'] as String,
            descriptionRu: row['descriptionRu'] as String,
            id: row['id'] as int,
            name: row['name'] as String,
            nameRu: row['nameRu'] as String,
            serverCount: row['serverCount'] as int,
            isVideo: (row['isVideo'] as int) != 0,
            isAudio: (row['isAudio'] as int) != 0,
            toUpdateCount: row['toUpdateCount'] as int),
        queryableName: 'Category',
        isView: false);
  }

  @override
  Future<List<Category>> getCategories() async {
    return _queryAdapter.queryList('SELECT * FROM Category',
        mapper: (Map<String, Object?> row) => Category(
            description: row['description'] as String,
            descriptionRu: row['descriptionRu'] as String,
            id: row['id'] as int,
            name: row['name'] as String,
            nameRu: row['nameRu'] as String,
            serverCount: row['serverCount'] as int,
            isVideo: (row['isVideo'] as int) != 0,
            isAudio: (row['isAudio'] as int) != 0,
            toUpdateCount: row['toUpdateCount'] as int));
  }

  @override
  Future<List<Category>> getAudioCategories() async {
    return _queryAdapter.queryList(
        'SELECT * FROM Category WHERE isAudio = true',
        mapper: (Map<String, Object?> row) => Category(
            description: row['description'] as String,
            descriptionRu: row['descriptionRu'] as String,
            id: row['id'] as int,
            name: row['name'] as String,
            nameRu: row['nameRu'] as String,
            serverCount: row['serverCount'] as int,
            isVideo: (row['isVideo'] as int) != 0,
            isAudio: (row['isAudio'] as int) != 0,
            toUpdateCount: row['toUpdateCount'] as int));
  }

  @override
  Future<Category?> getCategoryByID(int id) async {
    return _queryAdapter.query('SELECT * FROM Category WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Category(
            description: row['description'] as String,
            descriptionRu: row['descriptionRu'] as String,
            id: row['id'] as int,
            name: row['name'] as String,
            nameRu: row['nameRu'] as String,
            serverCount: row['serverCount'] as int,
            isVideo: (row['isVideo'] as int) != 0,
            isAudio: (row['isAudio'] as int) != 0,
            toUpdateCount: row['toUpdateCount'] as int),
        arguments: [id]);
  }

  @override
  Future<int> insertEntity(Category entity) {
    return _categoryInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateEntity(Category entity) async {
    await _categoryUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(Category entity) async {
    await _categoryDeletionAdapter.delete(entity);
  }
}

class _$ProfileDao extends ProfileDao {
  _$ProfileDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _profileInsertionAdapter = InsertionAdapter(
            database,
            'Profile',
            (Profile item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'nameRu': item.nameRu
                },
            changeListener),
        _profileUpdateAdapter = UpdateAdapter(
            database,
            'Profile',
            ['id'],
            (Profile item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'nameRu': item.nameRu
                },
            changeListener),
        _profileDeletionAdapter = DeletionAdapter(
            database,
            'Profile',
            ['id'],
            (Profile item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'nameRu': item.nameRu
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Profile> _profileInsertionAdapter;

  final UpdateAdapter<Profile> _profileUpdateAdapter;

  final DeletionAdapter<Profile> _profileDeletionAdapter;

  @override
  Future<Profile?> getProfileByID(int id) async {
    return _queryAdapter.query('SELECT * FROM Profile WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Profile(
            name: row['name'] as String,
            id: row['id'] as int?,
            nameRu: row['nameRu'] as String),
        arguments: [id]);
  }

  @override
  Stream<List<Profile>> getProfilesStream() {
    return _queryAdapter.queryListStream('SELECT * FROM Profile',
        mapper: (Map<String, Object?> row) => Profile(
            name: row['name'] as String,
            id: row['id'] as int?,
            nameRu: row['nameRu'] as String),
        queryableName: 'Profile',
        isView: false);
  }

  @override
  Future<int> insertEntity(Profile entity) {
    return _profileInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateEntity(Profile entity) async {
    await _profileUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(Profile entity) async {
    await _profileDeletionAdapter.delete(entity);
  }
}

class _$ProfileToCategoryDao extends ProfileToCategoryDao {
  _$ProfileToCategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _profileToCategoryInsertionAdapter = InsertionAdapter(
            database,
            'ProfileToCategory',
            (ProfileToCategory item) => <String, Object?>{
                  'id': item.id,
                  'profileID': item.profileID,
              'categoryID': item.categoryID
                },
            changeListener),
        _profileToCategoryUpdateAdapter = UpdateAdapter(
            database,
            'ProfileToCategory',
            ['id'],
            (ProfileToCategory item) => <String, Object?>{
                  'id': item.id,
                  'profileID': item.profileID,
              'categoryID': item.categoryID
                },
            changeListener),
        _profileToCategoryDeletionAdapter = DeletionAdapter(
            database,
            'ProfileToCategory',
            ['id'],
            (ProfileToCategory item) => <String, Object?>{
                  'id': item.id,
                  'profileID': item.profileID,
              'categoryID': item.categoryID
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProfileToCategory> _profileToCategoryInsertionAdapter;

  final UpdateAdapter<ProfileToCategory> _profileToCategoryUpdateAdapter;

  final DeletionAdapter<ProfileToCategory> _profileToCategoryDeletionAdapter;

  @override
  Future<List<ProfileToCategory>?> getCategoriesIDs(int profileID) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ProfileToCategory WHERE profileID = ?1',
        mapper: (Map<String, Object?> row) => ProfileToCategory(
            id: row['id'] as int?,
            profileID: row['profileID'] as int,
            categoryID: row['categoryID'] as int),
        arguments: [profileID]);
  }

  @override
  Stream<List<ProfileToCategory>?> getCategoriesIDsStream(int profileID) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM ProfileToCategory WHERE profileID = ?1',
        mapper: (Map<String, Object?> row) => ProfileToCategory(
            id: row['id'] as int?,
            profileID: row['profileID'] as int,
            categoryID: row['categoryID'] as int),
        arguments: [profileID],
        queryableName: 'ProfileToCategory',
        isView: false);
  }

  @override
  Future<int> insertEntity(ProfileToCategory entity) {
    return _profileToCategoryInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateEntity(ProfileToCategory entity) async {
    await _profileToCategoryUpdateAdapter.update(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(ProfileToCategory entity) async {
    await _profileToCategoryDeletionAdapter.delete(entity);
  }
}

class _$AudioSampleDao extends AudioSampleDao {
  _$AudioSampleDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _audioSampleInsertionAdapter = InsertionAdapter(
            database,
            'AudioSample',
                (AudioSample item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'path': item.path,
                  'lastEditDate': item.lastEditDate
                }),
        _audioSampleUpdateAdapter = UpdateAdapter(
            database,
            'AudioSample',
            ['id'],
                (AudioSample item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'path': item.path,
                  'lastEditDate': item.lastEditDate
                }),
        _audioSampleDeletionAdapter = DeletionAdapter(
            database,
            'AudioSample',
            ['id'],
                (AudioSample item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'path': item.path,
                  'lastEditDate': item.lastEditDate
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AudioSample> _audioSampleInsertionAdapter;

  final UpdateAdapter<AudioSample> _audioSampleUpdateAdapter;

  final DeletionAdapter<AudioSample> _audioSampleDeletionAdapter;

  @override
  Future<AudioSample?> getByID(int id) async {
    return _queryAdapter.query('SELECT * FROM AudioSample WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AudioSample(
            id: row['id'] as int?,
            name: row['name'] as String,
            path: row['path'] as String,
            lastEditDate: row['lastEditDate'] as int),
        arguments: [id]);
  }

  @override
  Future<List<AudioSample>> getAudioSamples() async {
    return _queryAdapter.queryList('SELECT * FROM AudioSample',
        mapper: (Map<String, Object?> row) => AudioSample(
            id: row['id'] as int?,
            name: row['name'] as String,
            path: row['path'] as String,
            lastEditDate: row['lastEditDate'] as int));
  }

  @override
  Future<int> insertEntity(AudioSample entity) {
    return _audioSampleInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateEntity(AudioSample entity) async {
    await _audioSampleUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(AudioSample entity) async {
    await _audioSampleDeletionAdapter.delete(entity);
  }
}

class _$AudioToCategoryDao extends AudioToCategoryDao {
  _$AudioToCategoryDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _audioSampleToCategoryInsertionAdapter = InsertionAdapter(
            database,
            'AudioSampleToCategory',
            (AudioSampleToCategory item) => <String, Object?>{
                  'id': item.id,
                  'audioSampleID': item.audioSampleID,
                  'categoryID': item.categoryID
                }),
        _audioSampleToCategoryUpdateAdapter = UpdateAdapter(
            database,
            'AudioSampleToCategory',
            ['id'],
            (AudioSampleToCategory item) => <String, Object?>{
                  'id': item.id,
                  'audioSampleID': item.audioSampleID,
                  'categoryID': item.categoryID
                }),
        _audioSampleToCategoryDeletionAdapter = DeletionAdapter(
            database,
            'AudioSampleToCategory',
            ['id'],
            (AudioSampleToCategory item) => <String, Object?>{
                  'id': item.id,
                  'audioSampleID': item.audioSampleID,
                  'categoryID': item.categoryID
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AudioSampleToCategory>
      _audioSampleToCategoryInsertionAdapter;

  final UpdateAdapter<AudioSampleToCategory>
      _audioSampleToCategoryUpdateAdapter;

  final DeletionAdapter<AudioSampleToCategory>
      _audioSampleToCategoryDeletionAdapter;

  @override
  Future<List<AudioSampleToCategory>?> getByCategory(int categoryID) async {
    return _queryAdapter.queryList(
        'SELECT * FROM AudioSampleToCategory WHERE categoryID = ?1',
        mapper: (Map<String, Object?> row) => AudioSampleToCategory(
            id: row['id'] as int?,
            audioSampleID: row['audioSampleID'] as int,
            categoryID: row['categoryID'] as int),
        arguments: [categoryID]);
  }

  @override
  Future<AudioSampleToCategory?> getByID(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM AudioSampleToCategory WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AudioSampleToCategory(
            id: row['id'] as int?,
            audioSampleID: row['audioSampleID'] as int,
            categoryID: row['categoryID'] as int),
        arguments: [id]);
  }

  @override
  Future<List<AudioSampleToCategory>?> getAll() async {
    return _queryAdapter.queryList('SELECT * FROM AudioSampleToCategory',
        mapper: (Map<String, Object?> row) => AudioSampleToCategory(
            id: row['id'] as int?,
            audioSampleID: row['audioSampleID'] as int,
            categoryID: row['categoryID'] as int));
  }

  @override
  Future<int> insertEntity(AudioSampleToCategory entity) {
    return _audioSampleToCategoryInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateEntity(AudioSampleToCategory entity) async {
    await _audioSampleToCategoryUpdateAdapter.update(
        entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(AudioSampleToCategory entity) async {
    await _audioSampleToCategoryDeletionAdapter.delete(entity);
  }
}

class _$VideoBookmarkDao extends VideoBookmarkDao {
  _$VideoBookmarkDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _videoBookmarkInsertionAdapter = InsertionAdapter(
            database,
            'VideoBookmark',
            (VideoBookmark item) => <String, Object?>{'videoID': item.videoID},
            changeListener),
        _videoBookmarkUpdateAdapter = UpdateAdapter(
            database,
            'VideoBookmark',
            ['videoID'],
            (VideoBookmark item) => <String, Object?>{'videoID': item.videoID},
            changeListener),
        _videoBookmarkDeletionAdapter = DeletionAdapter(
            database,
            'VideoBookmark',
            ['videoID'],
            (VideoBookmark item) => <String, Object?>{'videoID': item.videoID},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<VideoBookmark> _videoBookmarkInsertionAdapter;

  final UpdateAdapter<VideoBookmark> _videoBookmarkUpdateAdapter;

  final DeletionAdapter<VideoBookmark> _videoBookmarkDeletionAdapter;

  @override
  Future<List<VideoBookmark>?> getBookmarks() async {
    return _queryAdapter.queryList('SELECT * FROM VideoBookmark',
        mapper: (Map<String, Object?> row) =>
            VideoBookmark(videoID: row['videoID'] as String));
  }

  @override
  Stream<VideoBookmark?> getBookmarkByIDStream(String videoID) {
    return _queryAdapter.queryStream(
        'SELECT * FROM VideoBookmark WHERE videoID = ?1',
        mapper: (Map<String, Object?> row) =>
            VideoBookmark(videoID: row['videoID'] as String),
        arguments: [videoID],
        queryableName: 'VideoBookmark',
        isView: false);
  }

  @override
  Future<int> insertEntity(VideoBookmark entity) {
    return _videoBookmarkInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateEntity(VideoBookmark entity) async {
    await _videoBookmarkUpdateAdapter.update(entity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntity(VideoBookmark entity) async {
    await _videoBookmarkDeletionAdapter.delete(entity);
  }
}

// ignore_for_file: unused_element
final _preferenceEnumConverter = PreferenceEnumConverter();
