import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:music_player/common_widgets/sign_out_menu.dart';
import 'package:music_player/screens/music_player_screen.dart';
import 'package:music_player/screens/routes.dart';
import 'package:music_player/stores/home_store.dart';
import 'package:music_player/utils/padding_extensions.dart';
import 'package:music_player/utils/sharedpref_utils.dart';
import 'package:provider/provider.dart';

class Library extends StatefulWidget {
  // final User user;
  const Library({super.key});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  String searchValue = '';
  final TextEditingController _searchController = TextEditingController();
  late HomeStore _store;
  late int lastIndex;
  bool _isSearching = false;
  bool _isLoading = false;

  @override
  void initState() {
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
    _store.getdata();
    lastIndex = _store.musicList.length;
  }

  Future<dynamic> Logout() async {
    await FirebaseAuth.instance.signOut();
    SharedPrefs().clearAll();
    Navigator.of(context).pushReplacementNamed(AppRouter.welcomeScreen);
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Observer(builder: (context) {
      return Scaffold(
          appBar: AppBar(
              //elevation: 10,
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
                  : const Text("Library",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25.0))
                      .paddingOnly(left: 10, top: 5),
              //centerTitle: true,
              // backgroundColor: Colors.teal.shade700,
              shadowColor: Colors.white10,
              toolbarHeight: 80, // default is 56
              actions: _isSearching
                  ? [
                      IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: _stopSearch,
                      ),
                    ]
                  : [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _startSearch,
                      ),
                      const SignOutMenu(),
                    ]),
          body: _isSearching
              ? ListView.builder(
                  itemCount: _store.filteredMusicList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerScreen(
                                index: index,
                                playlistfetch: "Search",
                              ),
                              // PlayerScreen(response: musicList[index]),
                            ));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            child: FadeInImage.assetNetwork(
                                height: 30,
                                width: 30,
                                placeholder:
                                    "lib/assets/images/music_placeholder.png",
                                image: _store.filteredMusicList[index].image
                                    .toString(),
                                fit: BoxFit.fill),
                          ).paddingOnly(right: 10, bottom: 10),
                          SizedBox(
                            width: deviceSize.width * 0.75,
                            child: Text(
                              _store.filteredMusicList[index].title ?? '',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17),
                              overflow: TextOverflow.ellipsis,
                            ).paddingOnly(bottom: 5),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                    );
                  },
                ).paddingSymmetric(horizontal: 10)
              : Column(
                  children: [Flexible(flex: 10, child: customListCard())],
                ));
    });
  }

  Widget customListCard() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            // Navigator.of(context).pushNamed(AppRouter.playerScreen,
            //     arguments: PlayerScreen(response: musicList[index]));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayerScreen(
                    index: index,
                    playlistfetch: "library",
                  ),
                  // PlayerScreen(response: musicList[index]),
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: FadeInImage.assetNetwork(
                      height: MediaQuery.of(context).size.height * 0.091,
                      width: MediaQuery.of(context).size.width * 0.14,
                      placeholder: "lib/assets/images/music_placeholder.png",
                      image: _store.musicList[index].image.toString(),
                      fit: BoxFit.fill),
                ),
              ).paddingLTRB(left: 25, top: 4, right: 1, bottom: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _store.musicList[index].title.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      _store.musicList[index].artist.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ).paddingOnly(left: 10, right: 5),
              ),
              Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert_outlined)))
                  .paddingEnd(5)
            ],
          ),
        );
      },
      itemCount: _store.musicList.length,
    );
  }
}
