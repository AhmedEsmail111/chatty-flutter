import 'dart:io';
import 'file:///G:/Flutter/Projects/chatty/lib/utilities/constants.dart';
import 'package:chatty/firebase/cloud_firestore_service.dart';
import 'package:chatty/firebase/firebase_auth.dart';
import 'package:chatty/model/user.dart';
import 'package:chatty/page_view_items/chat_list_screen.dart';
import 'package:chatty/reusable_widgets/alert_dialogue.dart';
import 'package:chatty/reusable_widgets/show_or_hide_icon.dart';
import 'package:chatty/screens/login_screen.dart';
import 'file:///G:/Flutter/Projects/chatty/lib/firebase/storage_service.dart';
import 'package:chatty/utilities/image_picker_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import '../reusable_widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // two textController to controller the textField
  final textFieldEmailController = TextEditingController();
  final textFieldPasswordController = TextEditingController();
  final textFieldNameController = TextEditingController();

  // three variables for the name and the email and the password that will be saved in the firebase
  String _email = '';
  late String _password;
  String? _name;
  // bool to know when to spin the progress bar
  bool showSpinner = false;
  // a variable to control when to show the error message of both the text field
  bool _validatePassword = false;
  // a string to hold the error message of the password
  String? _passwordErrorMessage;
  // two bool to check if the email format is correct
  late bool _correctEmail;
  bool _hasError = false;
  // variable to handle registration exceptions[email]
  var _errorMessage;
  // a bool to handle if the password is hidden or not
  bool _secured = true;
  // a variable to hold the selected image by the user
  File? _image;
  // a variable to detect if user entered a name or not
  bool _nameError = false;

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
            CustomAlertDialogue(
                errorMessage: _errorMessage,
                onTap: () {
                  setState(() {
                    _errorMessage = null;
                  });
                }),
            SizedBox(
              height: 20.0,
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  backgroundColor: Color(0xff049EF7),
                  radius: 90.0,
                  child: profilePhoto(),
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            TextField(
              controller: textFieldNameController,
              keyboardType: TextInputType.name,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _name = value;
              },
              decoration: kTextFieldInputRegisterDecoration.copyWith(
                hintText: 'Enter your Name',
                errorText: _nameError ? 'please enter your name' : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: textFieldEmailController,
              keyboardType: TextInputType.emailAddress,
              textAlign: TextAlign.center,
              onChanged: (value) {
                _email = value;
              },
              decoration: kTextFieldInputRegisterDecoration.copyWith(
                hintText: 'Enter your Email Address',
                errorText:
                    _hasError ? 'please enter a valid email address' : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              controller: textFieldPasswordController,
              keyboardType: TextInputType.visiblePassword,
              textAlign: TextAlign.center,
              obscureText: _secured,
              onChanged: (value) {
                _password = value;
              },
              decoration: kTextFieldInputRegisterDecoration.copyWith(
                suffixIcon: PasswordStatusIcon(
                    isHidden: _secured,
                    onTap: () {
                      setState(() {
                        _secured ? _secured = false : _secured = true;
                      });
                    }),
                hintText: 'Enter your Password',
                errorText: _validatePassword ? _passwordErrorMessage : null,
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
            CustomButton(
              onTap: () {
                handleLogin();
              },
              colour: Colors.blueAccent,
              text: 'Register',
            ),
            ListTile(
              title: TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.id, (route) => false);
                },
                child: Text(
                  'you\'re an old friend🥰 ? Log in',
                  style: TextStyle(color: Color(0xff049EF7)),
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
    _correctEmail = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email.trim());
    setState(() {
      showSpinner = true;
    });
    // bunch of checks to see if there is any errors with the user input
    handleErrors();

    User newUser;
    if (!_validatePassword && !_hasError && !_nameError) {
      try {
        final user =
            await FirebaseAuthService.createUserWithEmail(_email, _password);
        if (user != null) {
          await FireStorageService.uploadImage(
              image: _image!, rootChild: 'profile pictures', child: _email);
          newUser = User(
              name: _name,
              email: user.user!.email,
              profilePhoto: user.user!.email!.toLowerCase(),
              uid: user.user!.uid);
          CloudFireStoreService.addUser(
            email: newUser.email,
            name: newUser.name,
            profilePhoto: newUser.profilePhoto,
            uid: newUser.uid,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            ChatListScreen.id,
            (route) => false,
          );
        }
        setState(() {
          showSpinner = false;
        });
      } on auth.FirebaseAuthException catch (signUpError) {
        switch (signUpError.message) {
          case "email-already-in-use":
          case "The email address is already in use by another account.":
            {
              setState(() {
                showSpinner = false;
                _errorMessage = signUpError;
              });
            }
        }
      }
    }
  }

  // handle email and password validation error
  void handleErrors() {
    if (textFieldNameController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        _nameError = true;
      });
    } else {
      _nameError = false;
    }
    if (textFieldEmailController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        _hasError = true;
      });
    } else {
      _hasError = false;
    }
    if (textFieldPasswordController.text.isEmpty) {
      setState(() {
        _passwordErrorMessage = 'please enter your password';
        _validatePassword = true;
        showSpinner = false;
      });
    } else
      _validatePassword = false;

    if (!_correctEmail) {
      setState(() {
        showSpinner = false;
        _hasError = true;
      });
    } else if (!_hasError && !_validatePassword && !_nameError) {
      showSpinner = true;
      _hasError = false;
    }
    if (textFieldPasswordController.text.trim().length < 8) {
      setState(() {
        _validatePassword = true;
        _passwordErrorMessage =
            'enter at least 9 digits ,1 capital letter, and 1 symbol ';
        showSpinner = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    textFieldPasswordController.dispose();
    textFieldEmailController.dispose();
  }

// show a picker for the user to choose where he wants to choose his photo
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () async {
                        var image = await (ImagePickerService.imgFromGallery());
                        var croppedImage = await _cropImage(image!);
                        setState(() {
                          _image = File(croppedImage.path);
                        });
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () async {
                      var image = await (ImagePickerService.imgFromCamera());
                      var croppedImage = await _cropImage(image!);
                      setState(() {
                        _image = File(croppedImage.path);
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

// a Widget to display according to whether the user chose a photo or not
  Widget profilePhoto() {
    return _image != null
        ? ClipOval(
            child: Image.file(
              _image!,
              width: 170.0,
              height: 170.0,
              fit: BoxFit.fill,
            ),
          )
        : Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(40.0)),
            width: 120.0,
            height: 120.0,
            child: Icon(
              Icons.add_a_photo_rounded,
              color: Colors.grey[700],
            ),
          );
  }

  Future<File> _cropImage(File image) async {
    var croppedFile = await (ImageCropper.cropImage(
      sourcePath: image.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      maxHeight: 350,
      maxWidth: 300,
      compressQuality: 40,
    ));
    return File(croppedFile!.path);
  }
}
