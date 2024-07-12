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
          actions: [
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [_deleteGame()];
                })
          ],
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

  PopupMenuEntry _deleteGame() {
    return PopupMenuItem(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Importante"),
                  content: Text("Deseja mesmo remover este jogo?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Sai do dialogo
                          Navigator.pop(context); // Sai dos detalhes
                          db.deleteGame(widget.gameId);
                          widget.updater();
                        },
                        child: Text("Sim")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Não"))
                  ],
                );
              });
        },
        child: Text("Deletar Jogo"));
  }

  FutureBuilder _futureGameDetails() {
    return FutureBuilder(
      future: db.getGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            var game = snapshot.data!.where((e) => e.id == widget.gameId).first;
            return Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    game.name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Data de lançamento: ${game.releaseDate.day}/${game.releaseDate.month}/${game.releaseDate.year}",
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
                    game.description,
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
