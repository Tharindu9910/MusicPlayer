import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:music_player/common_widgets/sign_out_menu.dart';
import 'package:music_player/screens/music_player_screen.dart';
import 'package:music_player/stores/home_store.dart';
import 'package:music_player/utils/padding_extensions.dart';
import 'package:provider/provider.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isSearching = false;
  late HomeStore _store;

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
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    int lastIndex = _store.favouriteMusicList.length;
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
                : const Text("Favourites",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25.0))
                    .paddingOnly(left: 5, top: 5),
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
        body: _store.favouriteMusicList.isEmpty
            ? const Center(child: Text("Empty List"))
            : ListView.builder(
                itemCount: _store.favouriteMusicList.length,
                itemBuilder: (context, index) {
                  final item = _store.favouriteMusicList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 17),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          item.image.toString(),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.more_vert_outlined)),
                      title: Text(item.title.toString()),
                      subtitle: Text(item.artist.toString()),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlayerScreen(
                                index: index,
                                playlistfetch: "favourites",
                              ),
                              // PlayerScreen(response: musicList[index]),
                            ));
                      },
                    ),
                  );
                },
              ),
      );
    });
  }
}
