import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_player/screens/routes.dart';
import 'package:music_player/utils/hex_color.dart';
import 'package:music_player/utils/sharedpref_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor("#D42427"),
      child: Image.asset(
        "asset/icon/list_music_black.png",
        fit: BoxFit.contain,
      ),
    );
  }

  startTimer() async {
    var duration = const Duration(milliseconds: 2000);
    return Timer(duration, navigate);
  }

  navigate() async {
    if (SharedPrefs().userEmail == "") {
      Navigator.of(context).pushReplacementNamed(AppRouter.welcomeScreen);
    } else {
      Navigator.of(context)
          .pushReplacementNamed(AppRouter.bottomNavigationScreen);
    }
  }
}
