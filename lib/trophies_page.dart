import 'package:flutter/material.dart';

class TrophiesPage extends StatelessWidget {
  const TrophiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "🏆 Чемпионы 2025 года",
          style: TextStyle(fontSize: 22, color: Colors.cyanAccent),
        ),
      ),
    );
  }
}
