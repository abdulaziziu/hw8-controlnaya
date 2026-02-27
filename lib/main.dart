import 'package:flutter/material.dart';
import 'navigation.dart';

void main() => runApp(const EsportApp());

class EsportApp extends StatelessWidget {
  const EsportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
        ),
      ),
      home: const MainNavigation(),
    );
  }
}
