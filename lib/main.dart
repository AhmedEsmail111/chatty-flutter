import 'package:chatty/page_view_items/chat_list_screen.dart';
import 'package:chatty/screens/home_screen.dart';
import 'package:chatty/screens/search_screen.dart';
import 'package:chatty/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatty/screens/login_screen.dart';
import 'package:chatty/screens/registration_screen.dart';
import 'package:chatty/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? HomeScreen.id
          : LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ChatListScreen.id: (context) => ChatListScreen(),
        SearchScreen.id: (context) => SearchScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
