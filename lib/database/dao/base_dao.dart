import 'package:floor/floor.dart';

@dao
abstract class BaseDao<T> {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertEntity(T entity);

  @update
  Future<void> updateEntity(T entity);

  @delete
  Future<void> deleteEntity(T entity);
}
