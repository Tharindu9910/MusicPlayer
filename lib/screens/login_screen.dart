import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_player/modals/firebase_auth.dart';
import 'package:music_player/modals/validator.dart';
import 'package:music_player/screens/bottom_navigation_screen.dart';
import 'package:music_player/modals/auth_provider.dart';
import 'package:music_player/screens/home_screen.dart';
import 'package:music_player/screens/routes.dart';
import 'package:music_player/utils/sharedpref_utils.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:music_player/utils/padding_extensions.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context)
          .pushReplacementNamed(AppRouter.bottomNavigationScreen);
    }

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: null,
          body: Consumer<AuthenticationProvider>(
            builder: (context, authProvider, child) {
              return FutureBuilder(
                  future: _initializeFirebase(),
                  builder: (context, snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {

                    //   // show a loading indicator
                    //   return const Center(child: CircularProgressIndicator());
                    // } else if (snapshot.connectionState ==
                    //     ConnectionState.done) {
                    //   // show the main content
                    if (snapshot.hasError) {
                      //display an error message
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
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
                                    image: AssetImage(
                                        'asset/icon/list_music_black.png'),
                                  ),
                                ),
                              ),
                              const Text(
                                "Welcome to Lyric Loom",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ).paddingOnly(top: 10, bottom: 20),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                        controller: email,
                                        validator: (value) =>
                                            Validator.validateEmail(
                                                email: value),
                                        decoration: const InputDecoration(
                                          labelText: "Email",
                                          suffixIcon: Icon(Icons.person),
                                          //icon at head of input
                                        )).paddingSymmetric(horizontal: 60),
                                    TextFormField(
                                        controller: password,
                                        obscureText: true,
                                        validator: (value) =>
                                            Validator.validatePassword(
                                              password: value,
                                            ),
                                        decoration: const InputDecoration(
                                          labelText: "Password",
                                          suffixIcon: Icon(Icons.key_sharp),
                                          //icon at head of input
                                        )).paddingSymmetric(horizontal: 60),
                                    SizedBox(
                                        height: deviceSize.height * 0.06,
                                        width: deviceSize.width * 0.4,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  _isLoading = true;
                                                });

                                                User? user =
                                                    await FirebaseAuthHelper
                                                        .signInUsingEmailPassword(
                                                  email: email.text,
                                                  password: password.text,
                                                );

                                                setState(() {
                                                  _isLoading = false;
                                                });

                                                if (user != null) {
                                                  //User? test = FirebaseAuth.instance.currentUser;
                                                  SharedPrefs()
                                                      .setUserEmail(email.text);

                                                  SharedPrefs().setUserPassword(
                                                      password.text);
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          AppRouter
                                                              .bottomNavigationScreen);
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.teal.shade700,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            child: const Text(
                                              "Login",
                                              style: TextStyle(fontSize: 20),
                                            ))).paddingOnly(top: 50),
                                  ],
                                ),
                              ),
                              const Text(
                                "Or Using",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ).paddingOnly(bottom: 10, top: 10),
                              SizedBox(
                                height: deviceSize.height * 0.06,
                                width: deviceSize.width * 0.4,
                                child: ElevatedButton.icon(
                                  icon: const FaIcon(FontAwesomeIcons.google),
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red.shade800,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      await authProvider
                                          .signInWithGoogle(context);
                                      if (authProvider.user != null) {
                                        SharedPrefs().setUserEmail(
                                            authProvider.user!.email!);
                                        SharedPrefs().setUserName(
                                            authProvider.user!.displayName!);
                                        SharedPrefs().setPhotoURL(
                                            authProvider.user!.photoURL!);
                                        Navigator.of(context)
                                            .pushReplacementNamed(AppRouter
                                                .bottomNavigationScreen);
                                      }
                                    } catch (error) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(error.toString())),
                                      );
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                  label: const Text('Google'),
                                ),
                              ),
                              // Row(
                              //   children: [
                              //     const Text(
                              //       "Dont have an account?",
                              //       style: TextStyle(
                              //           fontWeight: FontWeight.bold),
                              //     ).paddingEnd(5),
                              //     RichText(
                              //       text: TextSpan(
                              //           text: "Signup",
                              //           style: TextStyle(
                              //               color: Colors.blue.shade700),
                              //           recognizer: TapGestureRecognizer()
                              //             ..onTap = () {
                              //               Navigator.of(context)
                              //                   .pushReplacementNamed(
                              //                       AppRouter.signUpScreen);
                              //             }),
                              //     ),
                              //   ],
                              // ).paddingOnly(
                              //     top: 10, left: deviceSize.width * 0.26),
                              Visibility(
                                visible: _isLoading,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            ],
                          ).paddingTop(deviceSize.height * 0.2),
                        ),
                      );
                    }
                    // } else {
                    //   // Handle any other state (although the above conditions should cover all)
                    //   return Center(child: Text('Unexpected state'));
                    // }
                  });
            },
          ),
        ),
      ),
    );
  }
}
