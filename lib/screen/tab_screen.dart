import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myexpense/model/authmodel.dart';
import 'package:myexpense/screen/home_screen.dart';
import 'package:myexpense/screen/login_screen.dart';
import 'package:myexpense/screen/overview_screen.dart';
import 'package:provider/provider.dart';

class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final List<Map<String, Object>> _pages = [
    {
      'page': HomeScreen(),
      'title': 'Home',
    },
    {
      'page': OverviewScreen(),
      'title': 'Order',
    },
  ];

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<AuthModel>(context, listen: false).isLoggedIn) {
      return LoginScreen();
    }
    return Scaffold(
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black54,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assessment,
              size: 40.0,
            ),
            title: Text('Weekly Chart'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.assignment,
              size: 40.0,
            ),
            title: Text('Overview'),
          ),
        ],
      ),
    );
  }
}
