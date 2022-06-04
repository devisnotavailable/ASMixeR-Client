import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@entity
class Profile extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;
  final String nameRu;

  const Profile({required this.name, this.id, this.nameRu = ""});

  @override
  List<Object?> get props => [id, name];

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(id: json["id"], name: json["name"], nameRu: json["nameRu"]);
  }
}
