import 'package:flutter/material.dart';
import 'package:violence_app/styles/color.dart';

import '../screens/beranda_screen.dart';
import '../screens/dpmdppa/report_screen.dart';
import '../screens/profile/profile_screen.dart';

class BottomNavigationWidget extends StatefulWidget {
  final int initialIndex;
  final List<Widget> pages;

  const BottomNavigationWidget({
    Key? key,
    this.initialIndex = 0,
    this.pages = const <Widget>[
      HomePage(),
      ReportScreen(),
      ProfilePage(),
    ],
  }) : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Beranda'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'LAPOR!'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profil'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColor.primaryColor,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
