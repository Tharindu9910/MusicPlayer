class Playlist {
  final int id;
  final String title;
  final int duration;
  final bool isPublic;
  final bool isLovedTrack;
  final bool collaborative;
  final int nbTracks;
  final int fans;
  final String link;
  final String picture;
  final String pictureSmall;
  final String pictureMedium;
  final String pictureBig;
  final String pictureXl;
  final String checksum;
  final String tracklist;
  final String creationDate;
  final String md5Image;
  final String pictureType;
  final int timeAdd;
  final int timeMod;
  final Creator creator;
  final String type;

  Playlist({
    required this.id,
    required this.title,
    required this.duration,
    required this.isPublic,
    required this.isLovedTrack,
    required this.collaborative,
    required this.nbTracks,
    required this.fans,
    required this.link,
    required this.picture,
    required this.pictureSmall,
    required this.pictureMedium,
    required this.pictureBig,
    required this.pictureXl,
    required this.checksum,
    required this.tracklist,
    required this.creationDate,
    required this.md5Image,
    required this.pictureType,
    required this.timeAdd,
    required this.timeMod,
    required this.creator,
    required this.type,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      isPublic: json['public'],
      isLovedTrack: json['is_loved_track'],
      collaborative: json['collaborative'],
      nbTracks: json['nb_tracks'],
      fans: json['fans'],
      link: json['link'],
      picture: json['picture'],
      pictureSmall: json['picture_small'],
      pictureMedium: json['picture_medium'],
      pictureBig: json['picture_big'],
      pictureXl: json['picture_xl'],
      checksum: json['checksum'],
      tracklist: json['tracklist'],
      creationDate: json['creation_date'],
      md5Image: json['md5_image'],
      pictureType: json['picture_type'],
      timeAdd: json['time_add'],
      timeMod: json['time_mod'],
      creator: Creator.fromJson(json['creator']),
      type: json['type'],
    );
  }
}

class Creator {
  final int id;
  final String name;
  final String tracklist;
  final String type;

  Creator({
    required this.id,
    required this.name,
    required this.tracklist,
    required this.type,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'],
      name: json['name'],
      tracklist: json['tracklist'],
      type: json['type'],
    );
  }
}
