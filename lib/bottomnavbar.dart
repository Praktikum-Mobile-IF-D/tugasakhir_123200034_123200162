import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'profile.dart';
import 'schedule.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'discover.dart';
import 'main.dart';
import 'model/user.dart';

class BottomNavbar extends StatefulWidget {

  const BottomNavbar({Key? key}) : super(key: key);

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late Box<UserModel> _myBox;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(initialPage: _selectedIndex);

    _myBox = Hive.box(boxName);
    _openBox();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
      });
    });
  }
  void _openBox() async {
    await Hive.openBox<UserModel>(boxName);
    _myBox = Hive.box<UserModel>(boxName);
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _logout() {
    _myBox.close();
    _prefs.setBool('isLoggedIn', false);
    _prefs.remove('username');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyApp(isLoggedIn: false)),
    );
  }

  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Dashboard(),
      discover(),
      schedule(),
      profile(),
      Container(), // Empty container for logout
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onItemTapped,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Background,
        ),
        height: 70,

        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Background,
          currentIndex: _selectedIndex,
          selectedItemColor: Darkmode ? Color(0xFFD0FE42) : Colors.deepOrange,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == _widgetOptions.length - 1) {
              _logout();
            } else {
              _onItemTapped(index);
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.movie, size: 30),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_sharp, size: 30),
              label: 'Schedule',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout, size: 30),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}
