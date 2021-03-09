import 'package:chatty/firebase/cloud_firestore_service.dart';
import 'package:chatty/model/user.dart';
import 'package:chatty/reusable_widgets/custom_tile.dart';
import 'package:chatty/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

// a variable to control  the search textField
TextEditingController _searchTextFieldController = TextEditingController();
// a query to get a certain elements from the list
String _query = '';

class _SearchScreenState extends State<SearchScreen> {
  // a list to hold all the Users
  List<User> _usersList = [];

  @override
  void initState() {
    super.initState();
    CloudFireStoreService.fetchAllUsers(auth.FirebaseAuth.instance.currentUser)
        .then((value) {
      setState(() {
        _usersList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            child: Stack(
              children: [
                TextField(
                  autofocus: true,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                  controller: _searchTextFieldController,
                  decoration: InputDecoration(

                      // focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 10.0, top: 17.0, bottom: 10.0, right: 5.0),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _searchTextFieldController.clear();
                            _query = '';
                          });
                        },
                      ),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 27.0)),
                  cursorColor: Colors.white,
                  onChanged: (newValue) {
                    setState(() {
                      _query = newValue;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
      body: buildSuggestion(_query),
    );
  }

  buildSuggestion(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : _usersList
            .where((User user) =>
                (user.name!.toLowerCase().contains(query.toLowerCase())))
            .toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          User receiverUser = User(
            name: suggestionList[index].name,
            email: suggestionList[index].email,
            status: suggestionList[index].status,
            state: suggestionList[index].state,
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
          );
          return CustomTile(
            mini: false,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatScreen(receiver: receiverUser)));
            },
            leading: CircleAvatar(
              radius: 35.0,
              child: Image.asset('images/profile.png'),
            ),
            title: Text(
              suggestionList[index].name!,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
            subTitle: Text(
              suggestionList[index].name!,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
            ),
          );
        });
  }
}
