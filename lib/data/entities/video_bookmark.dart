import 'package:floor/floor.dart';

@entity
class VideoBookmark {
  @primaryKey
  final String videoID;

  VideoBookmark({required this.videoID});
}
