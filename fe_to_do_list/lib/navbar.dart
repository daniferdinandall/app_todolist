import 'package:flutter/material.dart';
import 'package:contact_dio/view/screen/home_page.dart';
import 'package:contact_dio/view/screen/profile_page.dart'; // Import halaman profil

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentPageIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomePage(),
    const ProfilePage()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Todolist'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}

class MyShared extends StatefulWidget {
  const MyShared({super.key});

  @override
  State<MyShared> createState() => _MySharedState();
}

class _MySharedState extends State<MyShared> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Profile'),
      )
    );
  }
}
