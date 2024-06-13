import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_player/firebase_options.dart';
import 'package:music_player/screens/routes.dart';
import 'package:music_player/modals/auth_provider.dart';
import 'package:music_player/screens/welcome_screen.dart';
import 'package:music_player/stores/home_store.dart';
import 'package:music_player/utils/sharedpref_utils.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); //initializing firebase
  SharedPrefs().init(); //initializing shared preferences
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final homeStore = HomeStore();

    return ChangeNotifierProvider(
        create: (_) => AuthenticationProvider(),
        child: MultiProvider(
          providers: [
            Provider<HomeStore>(
              create: (_) => homeStore,
              lazy: true,
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Music App',
            theme: ThemeData.dark(),
            // theme: ThemeData(
            //     brightness: Brightness.dark,
            //     primaryColor: Colors.black,
            //     colorScheme: ColorScheme.dark().copyWith(
            //       primary: Colors.black,
            //       secondary: Colors.white,
            //     ),
            //     useMaterial3: true,
            //     bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            //       selectedItemColor: Colors.white, // Color for selected item
            //       unselectedItemColor:
            //           Colors.white, // Color for unselected items
            //       selectedLabelStyle: TextStyle(
            //         color: Colors.white, // Label color for selected item
            //       ),
            //       unselectedLabelStyle: TextStyle(
            //         color: Colors.white, // Label color for unselected items
            //       ),
            //     ),
            //     elevatedButtonTheme: ElevatedButtonThemeData(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.green,
            //         foregroundColor: Colors.white,
            //       ),
            //     )),
            home: WelcomeScreen(),
            onGenerateRoute: AppRouter().onGenerateRoute,
          ),
        ));
  }
}
