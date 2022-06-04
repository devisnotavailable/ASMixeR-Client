class Channel {
  final Snippet snippet;
  final String id;

  Channel(
    this.snippet,
    this.id,
  );

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(Snippet.fromJson(json["snippet"]), json["id"]);
  }
}

class Snippet {
  final Thumbnails thumbnails;

  Snippet({
    required this.thumbnails,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(thumbnails: Thumbnails.fromJson(json['thumbnails']));
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
