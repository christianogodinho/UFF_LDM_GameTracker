import 'package:flutter/material.dart';
import 'package:game_tracker/pages/review_registration.dart';
import 'package:game_tracker/services/sqlite.dart';
import '../jsonmodels/game_model.dart';
import '../jsonmodels/review_model.dart';

class gameDetails extends StatefulWidget {
  int gameId;
  int? userId;
  String gameName;
  Function updater;

  gameDetails(this.gameId, this.gameName, this.userId, this.updater, {super.key});

  @override
  State<gameDetails> createState() => _gameDetailsState();
}

class _gameDetailsState extends State<gameDetails> {
  DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Detalhes do Jogo",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      body: Column(
        children: [
          _futureGameDetails(),
          _futureGameReviews(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: widget.userId != null,
        child: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 244, 242, 235),
          onPressed: () {
            showDialog(
              context: context,
              builder: (builder) {
                return ReviewRegistration(widget.gameId, widget.userId!, widget.gameName);
              });
          },
          child: Icon(Icons.add),
        )
      )
    );
  }

  FutureBuilder _futureGameDetails() {
    Future<List<GameModel>> games = db.getGames();
    return FutureBuilder(
      future: games,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    snapshot.data[widget.gameId - 1].name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Data de lançamento: ${snapshot.data[widget.gameId - 1].releaseDate.day}/${snapshot.data[widget.gameId - 1].releaseDate.month}/${snapshot.data[widget.gameId - 1].releaseDate.year}",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Divider(),
                  Text(
                    "Sinopse:",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    snapshot.data[widget.gameId - 1].description,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text("Erro ao carregar dados");
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  FutureBuilder _futureGameReviews() {
    Future<List<ReviewModel>> reviews =
        db.getReviewsByGame(widget.gameId.toString());

    return FutureBuilder(
      future: reviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Expanded(
                child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Text("Nota: ${snapshot.data![index].score}"),
                    Divider(),
                    Text(snapshot.data![index].description),
                  ],
                );
              },
            ));
          } else {
            return const Text("Erro ao carregar dados");
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
