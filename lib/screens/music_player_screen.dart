import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:music_player/modals/music_data_response.dart';
import 'package:music_player/stores/home_store.dart';
import 'package:music_player/utils/padding_extensions.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'package:drop_shadow_image/drop_shadow_image.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen({super.key, required this.index, required this.playlistfetch});
  final int index;
  final String playlistfetch;
  //final MusicDataResponse response;
  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late HomeStore _store;
  List<MusicDataResponse> musicList = [];
  final audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  late int currentplayIndex;
  late int lastIndex;
  // late var musicList;
  bool _looping = false;
  bool _shuffle = false;
  bool _isfavored = false;

  @override
  void initState() {
    currentplayIndex = widget.index;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store = Provider.of<HomeStore>(context);
    switch (widget.playlistfetch) {
      case "library":
        {
          musicList = _store.musicList; //Assign music list
        }
        break;
      case "favourites":
        {
          musicList = _store.favouriteMusicList; //Assign music list
        }
        break;
      case "Search":
        {
          musicList = _store.filteredMusicList; //Assign music list
        }
        break;
      case "Playlist":
        {
          musicList = _store.musicList; //Assign music list
        }
        break;
      default:
        {
          musicList = _store.musicList; //Assign music list
        }
        break;
    }

    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
    // listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    // listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
      lastIndex = musicList.length;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    String url;
    return Observer(builder: (context) {
      //final url = _store.myPlayList[currentplayIndex].picture.toString();
      if (widget.playlistfetch == "Playlist") {
        url = _store.myPlayList[currentplayIndex].picture.toString();
      } else {
        url = musicList[currentplayIndex].image.toString();
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Player",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
          ),
          centerTitle: true,
          toolbarHeight: 80,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              await audioPlayer.pause();
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: deviceSize.width * 0.80,
              height: deviceSize.height * 0.35,
              child: DropShadowImage(
                image: Image.network(url,
                    height: deviceSize.height / 2.9,
                    width: double.infinity,
                    fit: BoxFit.fill),
                borderRadius: 2,
                blurRadius: 15,
                offset: Offset(5, 5),
                scale: 1.05,
              ).paddingSymmetric(horizontal: 20),
            ).paddingTop(15),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                musicList[currentplayIndex].title.toString(),
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ).paddingOnly(left: 20, top: deviceSize.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    musicList[currentplayIndex].artist.toString(),
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ).paddingStart(20),
                SizedBox(
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            _isfavored = !_isfavored;
                          });
                          _store.addFavourites(currentplayIndex);
                        },
                        icon: Icon(
                          _isfavored
                              ? Icons.favorite
                              : Icons.favorite_outline_sharp,
                        ))).paddingEnd(5)
              ],
            ),
            Slider(
                value: position.inSeconds.toDouble(),
                min: 0,
                activeColor: Colors.white,
                max: duration.inSeconds.toDouble(),
                onChanged: (value) async {
                  final position = Duration(seconds: value.toInt());
                  await audioPlayer.seek(position);
                  // optional :Play audio if was paused
                  await audioPlayer.resume();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(formatTime(position)),
                Text(formatTime(duration - position)),
              ],
            ).paddingSymmetric(horizontal: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                child: IconButton(
                  icon: _shuffle
                      ? const Icon(Icons.shuffle_on_sharp)
                      : const Icon(
                          Icons.shuffle_outlined,
                        ),
                  onPressed: () async {
                    if (currentplayIndex > 0) {
                      if (!_looping) {
                        setState(() {
                          _shuffle = !_shuffle;
                        });
                      }
                    }
                  },
                  //icon: Icon(FontAwesomeIcons.shuffle),
                  iconSize: 25,
                ),
              ),
              SizedBox(
                child: IconButton(
                  onPressed: () async {
                    if (currentplayIndex > 0) {
                      if (_isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          currentplayIndex--;
                        });
                        setAudio();
                        //await audioPlayer.resume();
                      } else {
                        setState(() {
                          currentplayIndex--;
                        });
                        setAudio();
                        //await audioPlayer.resume();
                      }
                    }
                  },
                  icon: Icon(Icons.skip_previous_rounded),
                  iconSize: 35,
                ),
              ),
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.teal.shade500,
                child: IconButton(
                  onPressed: () async {
                    if (_isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.resume();
                    }
                  },
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  iconSize: 50,
                ),
              ),
              SizedBox(
                child: IconButton(
                  onPressed: () async {
                    if (currentplayIndex < lastIndex - 1) {
                      if (_isPlaying) {
                        await audioPlayer.pause();
                        setState(() {
                          currentplayIndex++;
                        });
                        setAudio();
                      } else {
                        setState(() {
                          currentplayIndex++;
                        });
                        setAudio();
                      }
                    }
                  },
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: 35,
                ),
              ),
              SizedBox(
                child: IconButton(
                  icon: _looping
                      ? const Icon(Icons.repeat_on_outlined)
                      : const Icon(
                          Icons.repeat,
                        ),
                  onPressed: () async {
                    if (!_shuffle) {
                      setState(() {
                        _looping = !_looping;
                      });
                    }
                  },
                  //icon: Icon(FontAwesomeIcons.repeat),
                  iconSize: 28,
                ),
              )
            ]).paddingSymmetric(horizontal: 20)
          ],
        ).paddingOnly(
          left: 35,
          right: 35,
          bottom: 35,
        ),
      );
    });
  }

  Future<void> setAudio() async {
    // Repeat song when completed
    //if (!widget.playlistfetch) {

    if (widget.playlistfetch == "Search") {
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      await audioPlayer
          .setSourceUrl(musicList[currentplayIndex].source.toString());
    } else {
      if (_looping) {
        audioPlayer.setReleaseMode(ReleaseMode.loop);
        await audioPlayer
            .setSourceUrl(musicList[currentplayIndex].source.toString());
      } else {
        setState(() {
          _isfavored = false;
        });
        audioPlayer.setReleaseMode(ReleaseMode.stop);
        await audioPlayer
            .setSourceUrl(musicList[currentplayIndex].source.toString());
        audioPlayer.onPlayerComplete.listen((event) {
          // Move to the next song index
          setState(() {
            if (_shuffle) {
              currentplayIndex = getRandomInt(1, lastIndex - 1);
            } else {
              currentplayIndex = (currentplayIndex + 1) % musicList.length;
            }
          });
          audioPlayer
              .setSourceUrl(musicList[currentplayIndex].source.toString());
          audioPlayer.resume();
        });
      }
    }
    //   } else {
    //     audioPlayer.setReleaseMode(ReleaseMode.stop);
    //     await audioPlayer
    //         .setSourceUrl(_store.myPlayList[currentplayIndex].link.toString());
    //     audioPlayer.onPlayerComplete.listen((event) {
    //       // Move to the next song index
    //       setState(() {
    //         currentplayIndex = (currentplayIndex + 1) % _store.myPlayList.length;
    //       });
    //       audioPlayer
    //           .setSourceUrl(_store.myPlayList[currentplayIndex].link.toString());
    //       audioPlayer.resume();
    //     });
    //   }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, twoDigitMinutes, twoDigitSeconds]
        .join(':');
  }
}
