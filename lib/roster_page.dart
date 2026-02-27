import 'package:flutter/material.dart';
import 'team_data.dart';
import 'player_page.dart';

class RosterPage extends StatelessWidget {
  const RosterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Состав команды")),
      body: ListView.builder(
        itemCount: players.length,
        itemBuilder: (context, index) {
          final player = players[index];
          return Card(
            child: ListTile(
              title: Text(player.nickname),
              subtitle: Text(player.role),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayerPage(player: player),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
