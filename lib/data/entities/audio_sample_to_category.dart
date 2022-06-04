import 'package:asmixer/data/entities/audio_sample.dart';
import 'package:floor/floor.dart';

import 'category.dart';

@Entity(foreignKeys: [
  ForeignKey(
      childColumns: ['categoryID'],
      parentColumns: ['id'],
      entity: Category,
      onDelete: ForeignKeyAction.cascade),
  ForeignKey(
      childColumns: ['audioSampleID'],
      parentColumns: ['id'],
      entity: AudioSample,
      onDelete: ForeignKeyAction.cascade)
])
class AudioSampleToCategory {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int audioSampleID;
  final int categoryID;

  AudioSampleToCategory({
    this.id,
    required this.audioSampleID,
    required this.categoryID,
  });

  factory AudioSampleToCategory.fromJson(Map<String, dynamic> json) {
    return AudioSampleToCategory(
        id: json['id'],
        audioSampleID: json['sampleId'],
        categoryID: json['categoryId']);
  }
}
