import 'package:chatty/screens/login_screen.dart';
import 'file:///G:/Flutter/Projects/chatty/lib/firebase/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  static const id = 'settings';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // the current user information
  late User _loggedInUser;
  // the url of the user's photo
  String? _userPhotoUrl;
  // a method to get the current user data
  void getCurrentUser() {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getImageUrl(
        context: context,
        path: 'profile pictures',
        imageName: _loggedInUser.email!.toLowerCase().trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 30.0,
                  color: Colors.black54,
                ),
              ),
              title: Text(
                'Settings',
              ),
            ),
            Container(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: 60.0,
                    child: ClipOval(
                        child: _userPhotoUrl != null
                            ? Image.network(
                                _userPhotoUrl!,
                                width: 115.0,
                                height: 115.0,
                                fit: BoxFit.fill,
                              )
                            : Image.asset(
                                'images/profile.png',
                                width: 115.0,
                                height: 115.0,
                                fit: BoxFit.fill,
                              )),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  FlatButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          LoginScreen.id,
                          (route) => false,
                        );
                      },
                      child: ListTile(
                        title: Text(
                          'Sign Out',
                          style: TextStyle(fontSize: 25.0),
                        ),
                        trailing: Icon(FontAwesomeIcons.signOutAlt),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getImageUrl(
      {required BuildContext context, required String path, required String imageName}) async {
    await FireStorageService.loadImage(
            context: context, mainPath: path, image: imageName)
        .then((value) {
      setState(() {
        _userPhotoUrl = value.toString();
      });
    });
  }
}
