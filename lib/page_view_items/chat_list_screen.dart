import 'package:chatty/reusable_widgets/custom_appbar.dart';
import 'package:chatty/reusable_widgets/custom_tile.dart';
import 'package:chatty/screens/search_screen.dart';
import 'package:chatty/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'file:///G:/Flutter/Projects/chatty/lib/firebase/storage_service.dart'
    as storageService;

class ChatListScreen extends StatefulWidget {
  static const id = 'main_chat_list';
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

// a variable to hold the current user'data
late auth.User loggedInUser;

class _ChatListScreenState extends State<ChatListScreen> {
  // the url of the profile picture of the user
  String? _userPhotoUrl;
  // an instance of the firebase authentication
  final _auth = auth.FirebaseAuth.instance;

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
      imageName: loggedInUser.email!.toLowerCase().trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: 0),
        child: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.id);
          },
          child: Icon(
            Icons.message_rounded,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        context: context,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.id);
            },
            icon: Icon(
              Icons.search_rounded,
              color: Colors.grey[600],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.grey[600],
            ),
          ),
        ],
        title: Text(
          'Chatty',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, SettingsScreen.id);
            },
            child: _userPhotoUrl != null
                ? CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20.0,
                    child: ClipOval(
                      child: Image.network(
                        _userPhotoUrl!,
                        width: 45.0,
                        height: 35.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        'images/profile.png',
                        width: 45.0,
                        height: 35.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
          ),
        ),
      ),
      body: ChatListContainer(
        currentUserId: loggedInUser.uid,
      ),
    );
  }

  void getImageUrl(
      {required BuildContext context, required String path, required String imageName}) async {
    await storageService.FireStorageService.loadImage(
            context: context, mainPath: path, image: imageName)
        .then((value) {
      setState(() {
        _userPhotoUrl = value.toString();
      });
    });
  }
}

class ChatListContainer extends StatefulWidget {
  final currentUserId;
  ChatListContainer({required this.currentUserId});
  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: 4,
          itemBuilder: (context, index) {
            return CustomTile(
              mini: false,
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) =>
                //             ChatScreen(receiver: User(name: 'Malek Hossam'))));
              },
              title: Text(
                'Malek Hossam',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                ),
              ),
              subTitle: Text(
                'Hello, dear',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                ),
              ),
              leading: Container(
                constraints: BoxConstraints(
                  maxWidth: 60.0,
                  maxHeight: 60.0,
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent[200],
                      maxRadius: 30.0,
                      child: Image.network(
                          'https://bramdejager.files.wordpress.com/2019/05/bramdejager-600x600.png?w=300'),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
