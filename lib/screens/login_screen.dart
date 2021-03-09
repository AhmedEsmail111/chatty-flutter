import 'package:chatty/firebase/firebase_auth.dart';
import 'package:chatty/reusable_widgets/alert_dialogue.dart';
import 'package:chatty/reusable_widgets/show_or_hide_icon.dart';
import 'package:chatty/screens/home_screen.dart';
import 'package:chatty/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utilities/constants.dart';
import '../reusable_widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // two textController to controller the textField
  final textFieldEmailController = TextEditingController();
  final textFieldPasswordController = TextEditingController();
  // tow variables for the email and the password that will be used to sign in
  late String _password;
  late String _email;
  // a variable to control when to show the spinner
  bool showSpinner = false;
  // two variable to control when to show the error message of both the text field
  bool _validateEmail = false;
  bool _validatePassword = false;
  // variable to handle login exceptions
  var _errorMessage;
  // a bool to handle if the password is hidden or not
  bool _secured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _errorMessage == null
                ? Flexible(
                    child: Container(
                      height: 200.0,
                      child: ClipOval(
                        child: Image.asset(
                          'images/icon hot.gif',
                        ),
                      ),
                    ),
                  )
                : CustomAlertDialogue(
                    errorMessage: _errorMessage,
                    onTap: () {
                      setState(() {
                        _errorMessage = null;
                      });
                    }),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              controller: textFieldEmailController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _email = value;
              },
              decoration: kTextFieldInputLoginDecoration.copyWith(
                hintText: 'Enter your Email Address',
                errorText:
                    _validateEmail ? 'please enter your email address' : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: textFieldPasswordController,
              obscureText: _secured,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _password = value;
              },
              decoration: kTextFieldInputLoginDecoration.copyWith(
                suffixIcon: PasswordStatusIcon(
                    isHidden: _secured,
                    onTap: () {
                      setState(() {
                        _secured ? _secured = false : _secured = true;
                      });
                    }),
                hintText: 'Enter your Password',
                errorText:
                    _validatePassword ? 'please enter your password' : null,
              ),
            ),
            SizedBox(
              height: 12.0,
            ),
            CustomButton(
              onTap: () {
                handleLogin();
              },
              colour: Color(0xff049EF7),
              text: 'Log in',
            ),
            SizedBox(
              height: 5.0,
            ),
            ListTile(
              title: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                child: Text(
                  'New here? Register',
                  style: TextStyle(color: Color(0xff10BAF2)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // a method to handle when a user clicks on the login button
  void handleLogin() async {
    setState(() {
      showSpinner = true;
    });

    //a bunch of checks to handle any unexpected errors
    handleErrors();
    // if there is no errors  then do the login work
    if (!_validatePassword && !_validateEmail) {
      try {
        await FirebaseAuthService.singInWithEmail(_email, _password);

        Navigator.pushNamedAndRemoveUntil(
          context,
          HomeScreen.id,
          (route) => false,
        );

        setState(() {
          showSpinner = false;
        });
      } on FirebaseAuthException catch (loginError) {
        var message =
            'there was a problem signing in. check your Email and Password, or create an account';
        if (loginError.message != null) {
          setState(() {
            _errorMessage = message;
            showSpinner = false;
          });
          print(message);
        }
      }
    }
  }

  void handleErrors() {
    if (textFieldEmailController.text.isEmpty) {
      setState(() {
        _validateEmail = true;
        showSpinner = false;
      });
    } else
      _validateEmail = false;

    if (textFieldPasswordController.text.isEmpty) {
      setState(() {
        _validatePassword = true;
        showSpinner = false;
      });
    } else
      _validatePassword = false;
  }

  @override
  void dispose() {
    super.dispose();
    textFieldPasswordController.dispose();
    textFieldEmailController.dispose();
  }
}

// switch (signUpError.message) {
//   case 'There is no user record corresponding to this identifier. The user may have been deleted.':
//     {
//       setState(() {
//         _errorMessage = signUpError.message;
//         showSpinner = false;
//       });
//     }
//     break;
//   case 'The password is invalid or the user does not have a password.':
//     {
//       setState(() {
//         _errorMessage = signUpError.message;
//         showSpinner = false;
//       });
//     }
//     break;
//   case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
//     {
//       setState(() {
//         _errorMessage = signUpError.message;
//         showSpinner = false;
//       });
//     }
//     break;
//   default:
//     print('no errors');
// }
