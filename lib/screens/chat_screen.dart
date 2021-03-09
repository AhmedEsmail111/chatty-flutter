import 'package:chatty/firebase/cloud_firestore_service.dart';
import 'package:chatty/model/message.dart';
import 'package:chatty/model/user.dart';
import 'package:chatty/utilities/constants.dart';
import 'package:chatty/utilities/image_picker_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_cropper/image_cropper.dart';
import 'file:///G:/Flutter/Projects/chatty/lib/firebase/storage_service.dart'
    as storageService;
import 'package:path/path.dart' as path;
import 'dart:io';

// an instance of the firebase fireStore
final _fireStore = FirebaseFirestore.instance;
// a variable to hold the current user'data
late auth.User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat';
  final User? receiver;
  ChatScreen({this.receiver});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// the url of the profile picture of the user
String? _userPhotoUrl;

class _ChatScreenState extends State<ChatScreen> {
  // the url of the selected image the user picked from the gallery
  late String _selectedUrl;
  // decides whether the textField is empty or not
  // to decide which icon we're gonna show
  bool hasValue = false;
  // textController to controller the textField
  final textFieldController = TextEditingController();
  // an instance of the firebase authentication
  final _auth = auth.FirebaseAuth.instance;
  // a variable to store the written message
  String? textMessage;
// focusNode of the text field
  FocusNode _focusNode = FocusNode();
  // a method to get the current user data
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
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
      imageName: widget.receiver!.email!.toLowerCase().trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.call_rounded,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.video_call_rounded,
              ),
            ),
          ),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            receiverPhoto(isMe: false, radius: 22.0),
            Text(widget.receiver!.name!),
          ],
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(widget.receiver),
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.only(bottom: 5.0, left: 5.0, top: 5.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          onTap: () {
                            _focusNode.requestFocus();
                          },
                          focusNode: _focusNode,
                          maxLines: 3,
                          minLines: 1,
                          controller: textFieldController,
                          onChanged: (value) {
                            textMessage = value;
                            textField();
                          },
                          decoration: kTextFieldSendMessages.copyWith(
                            prefixIcon: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  _focusNode.unfocus();
                                });
                              },
                              icon: Icon(
                                Icons.emoji_emotions,
                                color: Colors.blueAccent,
                                size: 25.0,
                              ),
                            ),
                          ),
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          children: [
                            IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  _focusNode.unfocus();
                                });
                                _showPicker(context);
                              },
                              icon: Icon(
                                Icons.attachment_rounded,
                                color: Colors.blueAccent,
                                size: 25.0,
                              ),
                            ),
                            hasValue == false
                                ? IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      setState(() {
                                        _focusNode.unfocus();
                                      });
                                      enableSendingImages(
                                          ImagePickerService.imgFromCamera());
                                    },
                                    icon: Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.blueAccent,
                                      size: 25.0,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40.0,
                    onPressed: () async {
                      if (hasValue) {
                        textFieldController.clear();
                        setState(() {
                          hasValue = false;
                        });
                        Message message = Message(
                          senderUid: loggedInUser.uid,
                          receiverUid: widget.receiver!.uid,
                          type: 'text',
                          message: textMessage,
                          time: DateTime.now().millisecondsSinceEpoch,
                          senderName: null,
                        );
                        CloudFireStoreService.sendAMessage(
                          senderUser: loggedInUser,
                          receiverUser: widget.receiver!,
                          message: message.message,
                          sender: message.senderUid,
                          receiver: message.receiverUid,
                          time: message.time,
                          type: message.type,
                        );
                      }
                    },
                    child: hasValue
                        ? Icon(
                            Icons.send,
                            color: Colors.blueAccent,
                            size: 35.0,
                          )
                        : Icon(
                            Icons.keyboard_voice,
                            color: Colors.blueAccent,
                            size: 35.0,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void textField() {
    if (textFieldController.text != '' &&
        textFieldController.text.trim() != '') {
      setState(() {
        hasValue = true;
      });
    } else {
      setState(() {
        hasValue = false;
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
            child: Container(
              color: Color(0xff757575),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 7.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Wrap(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        enableSendingImages(
                            ImagePickerService.imgFromGallery());
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 20.0,
                              right: 20.0,
                              bottom: 10.0,
                            ),
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.purpleAccent[400],
                              child: Icon(
                                Icons.photo_size_select_actual,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            'Gallery',
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        enableSendingImages(ImagePickerService.imgFromCamera());
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 20.0,
                              right: 20.0,
                              bottom: 10.0,
                            ),
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.pink,
                              child: Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Camera',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 20.0,
                              right: 20.0,
                              bottom: 10.0,
                            ),
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.indigo,
                              child: Icon(
                                Icons.insert_drive_file_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Document',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 20.0,
                              right: 20.0,
                              bottom: 10.0,
                            ),
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.orangeAccent[200],
                              child: Icon(
                                Icons.headset_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Audio',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 20.0,
                              right: 20.0,
                              bottom: 10.0,
                            ),
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.green[600],
                              child: Icon(
                                Icons.location_on_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Location',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 20.0,
                              right: 20.0,
                              bottom: 10.0,
                            ),
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.lightBlue,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              'Contact',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: 20.0,
                              top: 20.0,
                              right: 20.0,
                              bottom: 10.0,
                            ),
                            child: CircleAvatar(
                              radius: 30.0,
                              backgroundColor: Colors.indigoAccent[300],
                              child: Icon(
                                Icons.video_library_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 15.0),
                            child: Text(
                              'Video',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

// gets the image url and assign it to _userPhotoUrl variable
  void getImageUrl(
      {required BuildContext context,
      required String path,
      required String imageName}) async {
    await storageService.FireStorageService.loadImage(
            context: context, mainPath: path, image: imageName)
        .then((value) {
      setState(() {
        _userPhotoUrl = value.toString();
      });
    });
  }

  void enableSendingImages(Future<File?> function) async {
    var image = await function;
    if (image != null) {
      print(image);
      setState(() {
        _selectedUrl = path.basename(image.path);
      });

      var croppedFile = await (ImageCropper.cropImage(
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        sourcePath: image.path,
        maxHeight: 350,
        maxWidth: 300,
        compressQuality: 40,
      ));
      Message imageMessage;
      await storageService.FireStorageService.uploadImage(
              image: File(croppedFile!.path),
              rootChild: 'image message',
              child: _selectedUrl)
          .then((value) => {
                storageService.FireStorageService.loadImage(
                  context: context,
                  mainPath: 'image message',
                  image: _selectedUrl,
                ).then((value) => {
                      imageMessage = Message(
                        type: 'image',
                        time: DateTime.now().millisecondsSinceEpoch,
                        message: value.toString(),
                        senderUid: loggedInUser.uid,
                        receiverUid: loggedInUser.uid,
                      ),
                      CloudFireStoreService.sendAMessage(
                        senderUser: loggedInUser,
                        receiverUser: widget.receiver!,
                        message: imageMessage.message,
                        type: imageMessage.type,
                        sender: imageMessage.senderUid,
                        receiver: imageMessage.receiverUid,
                        time: imageMessage.time,
                      ),
                    })
              });
    }
  }
}

class MessageStream extends StatelessWidget {
  final User? receiver;
  MessageStream(this.receiver);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('messages')
          .doc(loggedInUser.uid)
          .collection(receiver!.uid!)
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        List<MessageBubble> messageWidgets = [];
        if (!snapshot.hasData) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepPurpleAccent[100],
              ),
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('message');
          final messageSender = message.get('sender');
          final currentUser = loggedInUser.uid;
          final messageType = message.get('type');
          final messageWidget = MessageBubble(
            receiver: receiver,
            type: messageType,
            message: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.all(10.0),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final User? receiver;
  final String? type;
  final String? sender;
  final String? message;
  final bool isMe;
  static const Radius messageRadius = Radius.circular(30.0);
  MessageBubble(
      {required this.receiver,
      required this.message,
      required this.sender,
      required this.isMe,
      required this.type});
  @override
  Widget build(BuildContext context) {
    return type == 'text'
        ? _textMessage(sender: sender, message: message!, isMe: isMe)
        : _imageMessage(sender: sender, message: message!, isMe: isMe);
  }

  // a method to handle a message containing a text
  Widget _textMessage(
      {String? sender, required String message, required bool isMe}) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                receiverPhoto(isMe: isMe, radius: 15.0),
                Material(
                  elevation: 3.0,
                  borderRadius: isMe
                      ? BorderRadius.only(
                          topLeft: messageRadius,
                          bottomLeft: messageRadius,
                          bottomRight: messageRadius,
                        )
                      : BorderRadius.only(
                          topRight: messageRadius,
                          bottomLeft: messageRadius,
                          bottomRight: messageRadius,
                        ),
                  color:
                      isMe ? Colors.blueAccent : Colors.deepPurpleAccent[100],
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                      message,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  // a method to handle a message containing an image
  Widget _imageMessage(
      {String? sender, required String message, required bool isMe}) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: 300,
      height: 300,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: receiverPhoto(isMe: isMe, radius: 15.0),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2.0),
                  child: ClipRRect(
                    borderRadius: isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(20.0),
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0),
                          ),
                    child: Image.network(
                      message,
                      width: 260,
                      height: 260,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

Widget receiverPhoto({required bool isMe, double? radius}) {
  return !isMe
      ? Container(
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: radius,
              backgroundImage: (_userPhotoUrl != null
                  ? NetworkImage(_userPhotoUrl!)
                  : AssetImage('images/profile.png')) as ImageProvider<Object>?,
            ),
          ),
        )
      : Container();
}
