import 'package:flutter/material.dart';

abstract class NavItemBase {
  final String title;
  final IconData icon;

  const NavItemBase({
    required this.title,
    required this.icon,
  });

  Widget buildPage();
}
