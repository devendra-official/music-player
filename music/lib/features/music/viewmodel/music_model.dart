class MusicModel {
  late List<Music> music;

  MusicModel(this.music);

  MusicModel.fromJson(List<dynamic> json) {
    music = json.map((item) => Music.fromJson(item as Map<String, dynamic>)).toList();
  }
}

class Music {
  late String movie;
  late String songUrl;
  late String songName;
  late String imageUrl;
  late String artist;
  late String color;

  Music({
    required this.artist,
    required this.color,
    required this.imageUrl,
    required this.movie,
    required this.songName,
    required this.songUrl,
  });

  Music.fromJson(Map<String, dynamic> json) {
    movie = json["movie"] as String;
    songUrl = json["musicurl"] as String;
    songName = json["name"] as String;
    imageUrl = json["imageurl"] as String;
    artist = json["artist"] as String;
    color = json["color"] as String;
  }
}
