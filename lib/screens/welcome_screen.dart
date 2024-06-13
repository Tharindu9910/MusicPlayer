import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/modals/auth_provider.dart';
import 'package:music_player/screens/routes.dart';
import 'package:music_player/utils/padding_extensions.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = false;

  // @override
  // void initState() {
  //   _initializeFirebase();
  //   super.initState();
  // }

  // Future<FirebaseApp> _initializeFirebase() async {
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();

  //   User? user = FirebaseAuth.instance.currentUser;

  //   if (user != null) {
  //     Navigator.of(context)
  //         .pushReplacementNamed(AppRouter.bottomNavigationScreen);
  //   }

  //   return firebaseApp;
  // }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: null,
      body: Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: deviceSize.height * 0.1,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        invertColors: true,
                        image: AssetImage('asset/icon/list_music_black.png'),
                      ),
                    ),
                  ),
                  const Text(
                    "Lyric Loom",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ).paddingTop(10),
                  const Text(
                    "Craft Your Beat..",
                    style: TextStyle(fontSize: 10),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Container(
                      height: deviceSize.height * 0.06,
                      width: deviceSize.width * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          borderRadius: BorderRadius.circular(4)),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(AppRouter.loginScreen);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontSize: 20),
                          ))).paddingOnly(top: 50),
                  Container(
                      height: deviceSize.height * 0.06,
                      width: deviceSize.width * 0.4,
                      decoration: BoxDecoration(
                          color: Colors.teal.shade700,
                          borderRadius: BorderRadius.circular(4)),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(AppRouter.signUpScreen);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700),
                          child: const Text(
                            "SignUp",
                            style: TextStyle(fontSize: 20),
                          ))).paddingOnly(top: 20),
                  Visibility(
                    visible: isLoading,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              ).paddingTop(deviceSize.height * 0.3),
            ),
          );
        },
      ),
    );
  }
}
