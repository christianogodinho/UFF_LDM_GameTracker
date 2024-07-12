// Essa classe é a representação de um jogo dentro da lista do dashboard

import 'package:flutter/material.dart';
import 'package:game_tracker/jsonmodels/game_model.dart';
import 'package:game_tracker/services/sqlite.dart';

import '../pages/game_details.dart';

class DashboardGame extends StatelessWidget {
  final GameModel game;
  final Function updater; // função que vai atualizar o estado do dashboard
  const DashboardGame(this.game, this.updater);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
          color: Color.fromARGB(255, 204, 220, 240),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: ListTile(
              title: Text(
                game.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Divider(),
                  Text(
                      "Lançado em: ${game.releaseDate.day}/${game.releaseDate.month}/${game.releaseDate.year}"),
                  Text("Média: ${game.averageScore}")
                ],
              ),
            ),
          )),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                gameDetails(game.id!, game.userId, game.name, updater),
          ),
        );
      },
    );
  }
}
