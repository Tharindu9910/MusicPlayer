import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_player/screens/favourites_screen.dart';
import 'package:music_player/screens/library_screen.dart';
import 'package:music_player/screens/profile_screen.dart';
import 'package:music_player/utils/hex_color.dart';
import 'package:music_player/screens/home_screen.dart';

enum BottomNavPage { home, library, favourites, profile }

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  BottomNavPage selectedPage = BottomNavPage.home;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      body: Stack(children: [
        _buildBottomNav(BottomNavPage.home),
        _buildBottomNav(BottomNavPage.library),
        _buildBottomNav(BottomNavPage.favourites),
        _buildBottomNav(BottomNavPage.profile),
      ]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // borderRadius: const BorderRadius.only(
          //     topRight: Radius.circular(500), topLeft: Radius.circular(0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 20,
                offset: const Offset(0, 30)),
          ],
        ),
        child: ClipRRect(
          // borderRadius: const BorderRadius.only(
          //     topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Theme(
            data: ThemeData(splashFactory: NoSplash.splashFactory),
            child: BottomNavigationBar(
              currentIndex: BottomNavPage.values.indexOf(selectedPage),
              type: BottomNavigationBarType.fixed,
              selectedItemColor: HexColor("#ffffff"),
              backgroundColor: Colors.black38,
              // gradient: LinearGradient(
              //     colors: [Colors.teal.shade900, Colors.blueGrey.shade900],
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //   ),
              selectedFontSize: 9,
              unselectedFontSize: 9,
              selectedLabelStyle: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
              unselectedLabelStyle: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontSize: 10, color: Colors.white),
              onTap: (index) {
                final currentSelectedItem = BottomNavPage.values[index];
                setState(() {
                  selectedPage = currentSelectedItem;
                });
              },
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.home_outlined, color: Colors.white),
                    activeIcon: Icon(
                      Icons.home,
                      color: HexColor("#ffffff"),
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.music_note_outlined,
                        color: Colors.white),
                    activeIcon: Icon(
                      Icons.music_note,
                      color: HexColor("#ffffff"),
                    ),
                    label: "library"),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.favorite_border_outlined,
                        color: Colors.white),
                    activeIcon: Icon(
                      Icons.favorite,
                      color: HexColor("#ffffff"),
                    ),
                    label: "Favourites"),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.person_3_outlined,
                        color: Colors.white),
                    activeIcon: Icon(
                      Icons.person,
                      color: HexColor("#ffffff"),
                    ),
                    label: "Profile")
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(BottomNavPage currentItem) {
    return Offstage(
      offstage: currentItem != selectedPage,
      child: _getScreen(context, currentItem),
    );
  }

  _getScreen(BuildContext context, BottomNavPage page) {
    switch (page) {
      case BottomNavPage.home:
        return const HomeScreen();
      case BottomNavPage.library:
        return const Library();
      case BottomNavPage.favourites:
        return const Favourites();
      case BottomNavPage.profile:
        return const MyProfile();
      default:
        return const Scaffold();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
