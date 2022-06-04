import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@entity
class Category extends Equatable {
  @primaryKey
  final int id;
  final String name;
  final String nameRu;
  final String description;
  final String descriptionRu;
  final int serverCount;
  final bool isVideo;
  final bool isAudio;
  final int
      toUpdateCount; //clientside, remember how much files we need to download

  const Category({
    this.description = "",
    this.descriptionRu = "",
    required this.id,
    required this.name,
    required this.nameRu,
    this.serverCount = 0,
    this.isVideo = true,
    this.isAudio = true,
    this.toUpdateCount = 0,
  });

  @override
  List<Object?> get props => [id];

  String getNameForLocale(bool isRussian) => isRussian ? nameRu : name;

  String getDescriptionForLocale(bool isRussian) =>
      isRussian ? descriptionRu : description;

  Category withUpdateCount(int toUpdateCount) {
    return Category(
        id: id,
        name: name,
        nameRu: nameRu,
        toUpdateCount: toUpdateCount,
        descriptionRu: descriptionRu,
        description: description,
        isAudio: isAudio,
        isVideo: isVideo,
        serverCount: serverCount);
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        name: json['name'],
        nameRu: json['nameRu'],
        description: json['description'],
        descriptionRu: json['descriptionRu'],
        serverCount: json['countSample'] ?? 0,
        isVideo: json['isVideo'],
        isAudio: json['isAudio']);
  }
}
