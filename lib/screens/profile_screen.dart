import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/modals/auth_provider.dart';
import 'package:music_player/modals/validator.dart';
import 'package:music_player/screens/routes.dart';
import 'package:music_player/utils/padding_extensions.dart';
import 'package:music_player/utils/sharedpref_utils.dart';

class MyProfile extends StatefulWidget {
  final String url =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/1200px-Windows_10_Default_Profile_Picture.svg.png";
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String userPhotoURL = "";
  bool _isLoading = false;
  final _formKey0 = GlobalKey<FormState>();
  TextEditingController updatedEmail = TextEditingController();
  TextEditingController updatedPassword = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      userPhotoURL = SharedPrefs().userPhotoURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("My Profile",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0))
                .paddingOnly(left: 10, top: 5),
            centerTitle: true,
            // backgroundColor: Colors.teal.shade700,
            shadowColor: Colors.white10,
            toolbarHeight: 80, // default is 56
            //leading: SizedBox.shrink(),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: deviceSize.width * 0.4,
                  height: deviceSize.width * 0.4,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(80),
                      child: Image.network(
                        userPhotoURL.isEmpty ? widget.url : userPhotoURL,
                        scale: 0.1,
                      )),
                ).paddingOnly(
                    left: deviceSize.width * 0.26,
                    right: deviceSize.width * 0.26,
                    top: 20),
                Text(
                  SharedPrefs().userName.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ).paddingOnly(
                    top: deviceSize.height * 0.02,
                    bottom: deviceSize.height * 0.02),
                Form(
                  key: _formKey0,
                  child: Column(
                    children: [
                      TextFormField(
                          controller: updatedEmail,
                          validator: (value) =>
                              Validator.validateEmail(email: value),
                          decoration: const InputDecoration(
                            labelText: "Email",
                            suffixIcon: Icon(Icons.person),
                            //icon at head of input
                          )).paddingSymmetric(horizontal: 60),
                      TextFormField(
                          controller: updatedPassword,
                          validator: (value) => Validator.validatePassword(
                                password: value,
                              ),
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: "Change Password",
                            suffixIcon: Icon(Icons.key_sharp),

                            //icon at head of input
                          )).paddingSymmetric(horizontal: 60),
                      // Container(
                      //     height: deviceSize.height * 0.06,
                      //     width: deviceSize.width * 0.4,
                      //     decoration: BoxDecoration(
                      //         color: Colors.teal.shade700,
                      //         borderRadius: BorderRadius.circular(4)),
                      //     child:
                      SizedBox(
                          height: deviceSize.height * 0.06,
                          width: deviceSize.width * 0.4,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey0.currentState!.validate()) {
                                  if (user != null) {
                                    user.updatePassword("$updatedPassword");
                                    await FirebaseAuth.instance
                                        .sendPasswordResetEmail(
                                            email: "${user.email}");
                                    SharedPrefs()
                                        .setUserEmail(updatedEmail.text);
                                    SharedPrefs()
                                        .setUserPassword(updatedPassword.text);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade700,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: const Text(
                                "Update",
                                style: TextStyle(fontSize: 18),
                              ))).paddingOnly(top: deviceSize.height * 0.05),
                      SizedBox(
                          height: deviceSize.height * 0.06,
                          width: deviceSize.width * 0.4,
                          child: ElevatedButton(
                              onPressed: () async {
                                AuthenticationProvider().signOut(context);
                                await FirebaseAuth.instance.signOut();
                                await user?.delete();
                                SharedPrefs().clearAll();
                                Navigator.of(context).pushReplacementNamed(
                                  AppRouter.welcomeScreen,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade700,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              child: const Text(
                                "Delete Account",
                                style: TextStyle(fontSize: 16.7),
                              ))).paddingTop(15)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
