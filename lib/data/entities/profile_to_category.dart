import 'package:asmixer/data/entities/category.dart';
import 'package:asmixer/data/entities/profile.dart';
import 'package:floor/floor.dart';

@Entity(foreignKeys: [
  ForeignKey(
      childColumns: ['profileID'],
      parentColumns: ['id'],
      entity: Profile,
      onDelete: ForeignKeyAction.cascade),
  ForeignKey(
      childColumns: ['categoryID'],
      parentColumns: ['id'],
      entity: Category,
      onDelete: ForeignKeyAction.cascade)
])
class ProfileToCategory {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int profileID;
  final int categoryID;

  ProfileToCategory(
      {this.id, required this.profileID, required this.categoryID});

  factory ProfileToCategory.fromJson(Map<String, dynamic> json) {
    return ProfileToCategory(
        profileID: json["profileID"], categoryID: json["categoryID"]);
  }
}
