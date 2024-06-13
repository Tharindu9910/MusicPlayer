import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:music_player/common_widgets/network_image.dart';
import 'package:music_player/common_widgets/sign_out_menu.dart';
import 'package:music_player/screens/music_player_screen.dart';
import 'package:music_player/stores/home_store.dart';
import 'package:music_player/utils/padding_extensions.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = false;
  late HomeStore _store;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _store = Provider.of<HomeStore>(context);
    _store.FetchData();
    //playlists = _store.playlist;
  }

  int getRandomInt(int min, int max) {
    final random = Random();
    return min + random.nextInt(max - min + 1);
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context);
    return Observer(builder: (context) {
      return Scaffold(
        appBar: AppBar(
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      hintStyle: TextStyle(color: Colors.white54),
                      border: UnderlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _store.performSearch(value);
                    },
                  ).paddingSymmetric(horizontal: 10)
                : const Text("Listn Now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0))
                    .paddingOnly(left: 5, top: 5),
            toolbarHeight: 80, // default is 56
            actions: _isSearching
                ? [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: _stopSearch,
                    ),
                  ]
                : [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: _startSearch,
                    ),
                    const SignOutMenu(),
                  ]),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "New Hits",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: 54.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ).paddingLTRB(left: 20.0, top: 5.0, right: 0.0, bottom: 0.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trending",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 26),
                      ),
                      Text(
                        "View all",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontSize: 15),
                      ),
                    ],
                  ).paddingOnly(left: 20, right: 20, top: 20),
                  SizedBox(
                      height: deviceSize.size.height * 0.34,
                      child: ListView.builder(
                          itemCount: _store.myPlayList.length,
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            var item = _store.myPlayList[index];
                            var deviceSize = MediaQuery.of(context).size;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlayerScreen(
                                          index: index,
                                          playlistfetch: "Playlist"),
                                      // PlayerScreen(response: musicList[index]),
                                    ));
                                // Navigator.of(context).pushNamed(
                                //     AppRouter.viewProductScreen,
                                //     arguments: ViewProductArgs(
                                //         productID: item.id ?? 1));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AppNetworkImage(
                                    imageUrl: item.picture,
                                    height: deviceSize.height * 0.2,
                                    width: deviceSize.width * 0.30,
                                  ),
                                  Row(
                                    children: [Text(item.title.toString())],
                                  ),
                                  SizedBox(
                                      width: deviceSize.width * .3,
                                      child: Text(
                                        item.creator.name.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  SizedBox(
                                      width: deviceSize.width * .25,
                                      child: Text(
                                        item.creator.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ],
                              ),
                            ).paddingSymmetric(horizontal: 10).paddingTop(10);
                          })).paddingSymmetric(horizontal: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recently Played",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      Text("View all",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontSize: 15)),
                    ],
                  ).paddingOnly(left: 20, right: 20),
                  SizedBox(
                      height: deviceSize.size.height * 0.34,
                      child: ListView.builder(
                          itemCount: _store.musicList.length,
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            int recentListIndex =
                                getRandomInt(0, _store.musicList.length - 1);
                            var item = _store.musicList[recentListIndex];
                            var deviceSize = MediaQuery.of(context).size;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlayerScreen(
                                          index: recentListIndex,
                                          playlistfetch: "library"),
                                      // PlayerScreen(response: musicList[index]),
                                    ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInImage.assetNetwork(
                                      image: item.image.toString(),
                                      placeholder:
                                          "lib/assets/images/music_placeholder.png",
                                      height: deviceSize.height * 0.169,
                                      width: deviceSize.width * 0.3,
                                      fit: BoxFit.fill),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: deviceSize.width * 0.3,
                                        child: Text(
                                          item.title.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ).paddingTop(8)
                                    ],
                                  ),
                                  SizedBox(
                                      width: deviceSize.width * .3,
                                      child: Text(
                                        item.album.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  SizedBox(
                                      width: deviceSize.width * .25,
                                      child: Text(
                                        item.artist.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ],
                              ),
                            ).paddingSymmetric(horizontal: 10).paddingTop(15);
                          })).paddingSymmetric(horizontal: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Most Popular",
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(
                                fontWeight: FontWeight.w500, fontSize: 25),
                      ),
                      Text("View all",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontSize: 15)),
                    ],
                  ).paddingOnly(left: 20, right: 20),
                  SizedBox(
                      height: deviceSize.size.height * 0.4,
                      child: ListView.builder(
                          itemCount: _store.musicList.length,
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            int recentListIndex =
                                getRandomInt(0, _store.musicList.length - 1);
                            var item = _store.musicList[recentListIndex];
                            var deviceSize = MediaQuery.of(context).size;
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PlayerScreen(
                                          index: recentListIndex,
                                          playlistfetch: "library"),
                                      // PlayerScreen(response: musicList[index]),
                                    ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInImage.assetNetwork(
                                      image: item.image.toString(),
                                      placeholder:
                                          "lib/assets/images/music_placeholder.png",
                                      height: deviceSize.height * 0.169,
                                      width: deviceSize.width * 0.3,
                                      fit: BoxFit.fill),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: deviceSize.width * 0.3,
                                        child: Text(
                                          item.title.toString(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ).paddingTop(8)
                                    ],
                                  ),
                                  SizedBox(
                                      width: deviceSize.width * .3,
                                      child: Text(
                                        item.album.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                  SizedBox(
                                      width: deviceSize.width * .25,
                                      child: Text(
                                        item.artist.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                ],
                              ),
                            ).paddingSymmetric(horizontal: 10).paddingTop(15);
                          })).paddingSymmetric(horizontal: 10),
                ],
              ),

              // Visibility(
              //     visible: _isLoading,
              //     child: const Center(child: CircularProgressIndicator()))
            ],
          ),
        ),
      );
    });
  }
}
