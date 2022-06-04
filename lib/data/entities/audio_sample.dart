import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@entity
class AudioSample extends Equatable {
  @primaryKey
  final int? id;
  final String name;
  final String path;
  final int lastEditDate;

  const AudioSample(
      {this.id, required this.name, required this.path, this.lastEditDate = 0});

  @override
  List<Object?> get props =>
      [id]; //consider 2 samples with same id as the same sample
}
