import 'package:chatty/page_view_items/chat_list_screen.dart';
import 'package:chatty/utilities/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // a controller to control the pageView
  PageController? _pageController;
  // a int to control in which page we are
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: onPageChange,
        children: [
          Container(
            child: ChatListScreen(),
          ),
          Center(
            child: Text('CALLS'),
          ),
          Center(
            child: Text('CONTACTS'),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          child: BottomNavigationBar(
            backgroundColor: Colors.blueAccent,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_rounded,
                    color: _page == 0 ? Colors.white : Colors.grey,
                  ),
                  title: Text(
                    'Chats',
                    style: TextStyle(
                      fontSize: kBottomNavLabelSize,
                      color: _page == 0 ? Colors.white : Colors.grey,
                    ),
                  )),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.call_rounded,
                  color: _page == 1 ? Colors.white : Colors.grey,
                ),
                title: Text('Calls',
                    style: TextStyle(
                      fontSize: kBottomNavLabelSize,
                      color: _page == 1 ? Colors.white : Colors.grey,
                    )),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.contacts_rounded,
                  color: _page == 2 ? Colors.white : Colors.grey,
                ),
                title: Text('Contacts',
                    style: TextStyle(
                      fontSize: kBottomNavLabelSize,
                      color: _page == 2 ? Colors.white : Colors.grey,
                    )),
              ),
            ],
            onTap: (index) {
              onTapped(index);
            },
            currentIndex: _page,
          ),
        ),
      ),
    );
  }

  void onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  void onTapped(int page) {
    _pageController!.jumpToPage(page);
  }
}
