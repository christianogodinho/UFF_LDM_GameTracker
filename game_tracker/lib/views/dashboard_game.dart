// Essa classe é a representação de um jogo dentro da lista do dashboard

import 'package:flutter/material.dart';
import 'package:game_tracker/jsonmodels/game_model.dart';

class DashboardGame extends StatelessWidget {
  final GameModel game;

  DashboardGame(this.game);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // ToDo: Expansão dos detalhes do jogo
      child: Card(
        margin: EdgeInsets.all(8),
        color: Color.fromARGB(255, 243, 236, 172),
        child: Column(
          // Temporário
          children: [
            Text(game.name),
            Text(game.releaseDate.toString()),
            Text("Placeholder para as médias")
          ],
        ),
      ),
    );
  }
}
