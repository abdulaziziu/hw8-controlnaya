import 'package:flutter/material.dart';
import 'player.dart';

class PlayerPage extends StatelessWidget {
  final Player player;

  const PlayerPage({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(player.nickname)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          player.bio,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
