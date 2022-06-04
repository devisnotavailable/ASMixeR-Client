class Video {
  final String videoID;
  final Snippet snippet;

  Video(this.videoID, this.snippet);

  factory Video.fromJson(Map<String, dynamic> json) {
    String videoID;
    if (json["id"] is String) {
      videoID = json["id"];
    } else {
      videoID = json["id"]['videoId'];
    }
    return Video(videoID, Snippet.fromJson(json["snippet"]));
  }
}

class Snippet {
  final Thumbnails thumbnails;
  final String title;
  final String description;
  final String channelTitle;
  final String channelID;

  Snippet(
      {required this.channelTitle,
      required this.title,
      required this.thumbnails,
      required this.description,
      required this.channelID});

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(
        thumbnails: Thumbnails.fromJson(json['thumbnails']),
        title: json['title'],
        channelTitle: json['channelTitle'],
        description: json['description'],
        channelID: json['channelId']);
  }
}

class Thumbnails {
  final Thumbnail mediumThumbnail;
  final Thumbnail highThumbnail;
  final Thumbnail defaultThumbnail;

  Thumbnails(
      {required this.mediumThumbnail,
      required this.highThumbnail,
      required this.defaultThumbnail});

  factory Thumbnails.fromJson(Map<String, dynamic> json) {
    return Thumbnails(
        mediumThumbnail: Thumbnail.fromJson(json['medium']),
        highThumbnail: Thumbnail.fromJson(json['high']),
        defaultThumbnail: Thumbnail.fromJson(json['default']));
  }
}

class Thumbnail {
  final String url;
  final int height;

  Thumbnail({required this.height, required this.url});

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(url: json['url'], height: json['height']);
  }
}
