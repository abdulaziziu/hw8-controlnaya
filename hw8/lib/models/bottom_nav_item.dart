import 'package:flutter/material.dart';
import 'nav_item_base.dart';

class BottomNavItem extends NavItemBase {
  final Widget page;

  const BottomNavItem({
    required super.title,
    required super.icon,
    required this.page,
  });

  @override
  Widget buildPage() => page;
}
