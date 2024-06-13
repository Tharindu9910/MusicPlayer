import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_player/modals/auth_provider.dart';
import 'package:music_player/screens/routes.dart';
import 'package:music_player/screens/welcome_screen.dart';
import 'package:music_player/utils/padding_extensions.dart';
import 'package:music_player/utils/sharedpref_utils.dart';

class SignOutMenu extends StatefulWidget {
  final String url =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Windows_10_Default_Profile_Picture.svg/1200px-Windows_10_Default_Profile_Picture.svg.png";
  const SignOutMenu({super.key});

  @override
  State<SignOutMenu> createState() => _SignOutMenuState();
}

class _SignOutMenuState extends State<SignOutMenu> {
  String userPhotoURL = "";
  @override
  void initState() {
    super.initState();
    setState(() {
      userPhotoURL = SharedPrefs().userPhotoURL;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.08,
        height: MediaQuery.of(context).size.width * 0.08,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              userPhotoURL.isEmpty ? widget.url : userPhotoURL,
              scale: 3,
            )),
      ),
      onSelected: (value) async {
        if (value == "logout") {
          AuthenticationProvider().signOut(context);
          if (mounted) {
            await FirebaseAuth.instance.signOut();
            SharedPrefs().clearAll();
            Navigator.of(context).pushReplacementNamed(
              AppRouter.welcomeScreen,
            );
          }

          // add desired output
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        const PopupMenuItem(
          value: "logout",
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.logout)),
              Text(
                'Logout',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    ).paddingEnd(15);
  }
}
