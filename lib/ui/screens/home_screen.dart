import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:wally/ui/screens/explore_screen.dart';
import 'package:wally/ui/screens/favourite_screen.dart';
import 'package:wally/ui/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;
  var _pages = [
    ExploreScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];
  void _changePage(int i) => setState(() => _selectedPage = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _changePage,
        currentIndex: _selectedPage,
        backgroundColor: Colors.white,
        elevation: 6.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Ionicons.ios_search_outline),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.ios_play_circle_outline),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Ionicons.ios_person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
