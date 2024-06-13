import 'package:flutter/material.dart';
import 'package:music_player/screens/bottom_navigation_screen.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/login_screen.dart';
import 'package:music_player/screens/signup_screen.dart';
import 'package:music_player/screens/welcome_screen.dart';

class AppRouter {
  static const String welcomeScreen = "/welcomeScreen",
      loginScreen = "/loginScreen",
      signUpScreen = "/signUpScreen",
      bottomNavigationScreen = "/bottomNavigationScreen",
      homeScreen = "/homeScreen";
  // playerScreen = "/playerScreen";

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case welcomeScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const WelcomeScreen(),
        );
      case loginScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        );
      case signUpScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignUpScreen(),
        );
      case bottomNavigationScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const BottomNavScreen(),
        );
      case homeScreen:
        return MaterialPageRoute(
          builder: (BuildContext context) => const HomeScreen(),
        );
      // case playerScreen:
      //   PlayerScreen response;
      //   if (routeSettings.arguments != null) {
      //     response = routeSettings.arguments as PlayerScreen;
      //   } else {
      //     //response = PlayerScreen(response: musicList[1]);
      //   }
      //   return MaterialPageRoute(
      //     builder: (BuildContext context) => const HomeScreen(),
      //   );

      default:
        return null;
    }
  }
}
