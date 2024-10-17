import 'package:flutter/material.dart';
import 'package:tinder_new/data/model/top_navigation_item.dart';
import 'package:tinder_new/ui/screens/top_navigation_screens/locations_screen.dart';
import 'package:tinder_new/ui/screens/top_navigation_screens/profile_screen.dart';
import 'package:tinder_new/ui/screens/top_navigation_screens/chats_screen.dart';
import 'package:tinder_new/ui/screens/top_navigation_screens/match_screen.dart';

class TopNavigationScreen extends StatefulWidget {
  static const String id = 'top_navigation_screen';

  TopNavigationScreen({Key? key}) : super(key: key);

  @override
  _TopNavigationScreenState createState() => _TopNavigationScreenState();
}

class _TopNavigationScreenState extends State<TopNavigationScreen> {
  int _currentIndex = 0;

  final List<TopNavigationItem> navigationItems = [
    TopNavigationItem(
      screen: const MatchScreen(),
      iconData: Icons.favorite,
    ),
    TopNavigationItem(
      screen: const ChatsScreen(),
      iconData: Icons.message_rounded,
    ),
    TopNavigationItem(
      screen: const ProfileScreen(),
      iconData: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationItems[_currentIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: navigationItems
            .map((navItem) => BottomNavigationBarItem(
          icon: Icon(navItem.iconData),
          label: '',
        ))
            .toList(),
      ),
    );
  }
}
