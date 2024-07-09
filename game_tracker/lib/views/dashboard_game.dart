// Essa classe é a representação de um jogo dentro da lista do dashboard

import 'package:flutter/material.dart';
import 'package:game_tracker/jsonmodels/game_model.dart';
import 'package:game_tracker/services/sqlite.dart';

class DashboardGame extends StatelessWidget {
  final GameModel game;

  DashboardGame(this.game);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // ToDo: Expansão dos detalhes do jogo
        child: Card(
      color: Color.fromARGB(255, 204, 220, 240),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          // Temporário
          children: [
            Text(game.name),
            Text(
                "Lançado em: ${game.releaseDate.day}/${game.releaseDate.month}/${game.releaseDate.year}"),
            FutureBuilder(
                future: DatabaseHelper().getAverageReviews(game),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Text("Não há reviews");
                  } else if (snapshot.hasData) {
                    return Text("Média: ${snapshot.data!}");
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    ));
  }
}
