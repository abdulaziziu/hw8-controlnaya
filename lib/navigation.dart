import 'package:flutter/material.dart';
import 'home_page.dart';
import 'roster_page.dart';
import 'trophies_page.dart';
import 'about_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    RosterPage(),
    TrophiesPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white54,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: "Состав"),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Трофеи"),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: "О команде"),
        ],
      ),
    );
  }
}
