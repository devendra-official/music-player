class MusicModel {
  late List<Music> music;

  MusicModel(this.music);

  MusicModel.fromJson(List<dynamic> json) {
    music = json
        .map((item) => Music.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class Music {
  late int id;
  late String album;
  late String songUrl;
  late String songName;
  late String imageUrl;
  late String artist;
  late String language;

  Music({
    required this.id,
    required this.artist,
    required this.language,
    required this.imageUrl,
    required this.album,
    required this.songName,
    required this.songUrl,
  });

  Music.fromJson(Map<String, dynamic> json) {
    album = json["album"] as String;
    id = json["id"] as int;
    songUrl = json["musicurl"] as String;
    songName = json["name"] as String;
    imageUrl = json["imageurl"] as String;
    artist = json["artist"] as String;
    language = json["language"] as String;
  }
}
