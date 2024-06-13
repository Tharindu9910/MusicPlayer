import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music_player/modals/auth_provider.dart';
import 'package:music_player/modals/firebase_auth.dart';
import 'package:music_player/modals/validator.dart';
import 'package:music_player/screens/routes.dart';
import 'package:music_player/screens/welcome_screen.dart';
import 'package:music_player/utils/padding_extensions.dart';
import 'package:music_player/utils/sharedpref_utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();
  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
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
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            invertColors: true,
                            image:
                                AssetImage('asset/icon/list_music_black.png'),
                          ),
                        ),
                      ),
                      const Text(
                        "Create New Account",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ).paddingOnly(top: 10, bottom: 20),
                      Form(
                        key: _registerFormKey,
                        child: Column(
                          children: [
                            TextFormField(
                                controller: name,
                                validator: (value) =>
                                    Validator.validateName(name: value),
                                decoration: const InputDecoration(
                                  labelText: "Name",
                                  suffixIcon: Icon(Icons.person),
                                  //icon at head of input
                                )).paddingSymmetric(horizontal: 60),
                            TextFormField(
                                controller: email,
                                validator: (value) =>
                                    Validator.validateEmail(email: value),
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  suffixIcon: Icon(Icons.mail_sharp),
                                  //icon at head of input
                                )).paddingSymmetric(horizontal: 60),
                            TextFormField(
                                controller: password,
                                validator: (value) =>
                                    Validator.validatePassword(password: value),
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
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        User? user = await FirebaseAuthHelper
                                            .registerUsingEmailPassword(
                                          name: name.text,
                                          email: email.text,
                                          password: password.text,
                                        );

                                        setState(() {
                                          _isLoading = false;
                                        });

                                        if (user != null) {
                                          SharedPrefs().setUserName(name.text);
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                                  AppRouter.welcomeScreen);

                                          // Navigator.of(context)
                                          //     .pushAndRemoveUntil(
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         WelcomeScreen(),
                                          //   ),
                                          //   ModalRoute.withName('/'),
                                          // );
                                        }
                                      } else {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal.shade700,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    child: const Text(
                                      "Signup",
                                      style: TextStyle(fontSize: 20),
                                    ))).paddingOnly(top: 50),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            "I Have an account?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ).paddingEnd(5),
                          RichText(
                            text: TextSpan(
                                text: "Login",
                                style: TextStyle(color: Colors.blue.shade700),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacementNamed(
                                        AppRouter.loginScreen);
                                  }),
                          ),
                        ],
                      ).paddingOnly(top: 10, left: deviceSize.width * 0.31),
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
            },
          ),
        ),
      ),
    );
  }
}
