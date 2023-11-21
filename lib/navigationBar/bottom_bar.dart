import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatelessWidget {
  int selectedIndex = 0;

  var onTabTapped;

  BottomNavigationWidget({
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(
                Icons.home_outlined
            ),
            label: 'Beranda'
        ),
        BottomNavigationBarItem(
            icon: Icon(
                Icons.people_rounded
            ), label: 'Komunitas'
        ),
        BottomNavigationBarItem(
            icon: Icon(
                Icons.add_circle_outline
            ), label: 'LAPOR!'
        ),
        BottomNavigationBarItem(
            icon: Icon(
                Icons.notifications
            ), label: 'Notifikasi!'
        ),
        BottomNavigationBarItem(
            icon: Icon(
                Icons.account_circle_outlined
            ), label: 'Profil!'
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onTabTapped,
    );
  }
}
