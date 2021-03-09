// FutureBuilder(
//   future:
//       getImage(context, loggedInUser.email.toLowerCase().trim()),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.done) {
//       return CircleAvatar(
//         backgroundImage: AssetImage('images/profile.png'),
//         backgroundColor: Color(0xffFDCF09),
//         radius: 27.0,
//         child: ClipOval(child: snapshot.data),
//       );
//     } else if (snapshot.connectionState ==
//         ConnectionState.waiting) {
//       return ClipOval(
//         child: Image.asset(
//           'images/profile.png',
//           width: 55.0,
//           height: 55.0,
//         ),
//       );
//     }
//     return Container();
//   },
// ),

//----==--------------------

// a variable to control the focusness of the TextField
// FocusNode _textFieldFocusController = FocusNode();
// // a variable to control whether the emoji container or not
// bool _showPicker = false;
// // two methods to manipulate whether the textFieldKeyBoard has focus or not
// hideTextFieldKeyBoard() => _textFieldFocusController.unfocus();
// showTextFieldKeyBoard() => _textFieldFocusController.requestFocus();
// // two methods to manipulate whether the emoji picker is visible or not
// showEmojiPicker() {
//   setState(() {
//     _showPicker = true;
//   });
// }
//
// hideEmojiPicker() {
//   setState(() {
//     _showPicker = false;
//   });
// }

//===================

// Widget emojiContainer() {
//   // return EmojiPicker(
//   //   rows: 3,
//   //   columns: 7,
//   //   recommendKeywords: ["racing", "horse"],
//   //   numRecommended: 10,
//   //   onEmojiSelected: (emoji, category) {
//   //     print(emoji);
//   //   },
//   // );
// }

//=================== welcome===========================
// import '../reusable_widgets/custom_button.dart';
// import 'package:chatty/screens/login_screen.dart';
// import 'package:chatty/screens/registration_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:animated_text_kit/animated_text_kit.dart';
//
// class WelcomeScreen extends StatefulWidget {
//   static const String id = 'welcome';
//   @override
//   _WelcomeScreenState createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen>
//     with SingleTickerProviderStateMixin {
//   // defining an animation controller
//   AnimationController _controller;
//   // defining a variable for the curved and tween animation
//   Animation _animation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       duration: Duration(seconds: 1),
//       vsync: this,
//     );
//
//     _animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
//         .animate(_controller);
//     _controller.forward();
//
//     _controller.addListener(() {
//       setState(() {});
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _animation.value,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Hero(
//                   tag: 'logo',
//                   child: Container(
//                     child: Image.asset('images/logo.png'),
//                     height: _controller.value * 60,
//                   ),
//                 ),
//                 TypewriterAnimatedTextKit(
//                   text: ['Flash Chat'],
//                   speed: Duration(milliseconds: 150),
//                   repeatForever: false,
//                   textStyle: TextStyle(
//                     color: Colors.black,
//                     fontSize: 45.0,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(
//               height: 48.0,
//             ),
//             CustomButton(
//               onTap: () {
//                 Navigator.pushNamed(
//                   context,
//                   LoginScreen.id,
//                 );
//               },
//               colour: Colors.lightBlueAccent,
//               text: 'Log in',
//             ),
//             CustomButton(
//               onTap: () {
//                 Navigator.pushNamed(
//                   context,
//                   RegistrationScreen.id,
//                 );
//               },
//               colour: Colors.blueAccent,
//               text: 'Register',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
