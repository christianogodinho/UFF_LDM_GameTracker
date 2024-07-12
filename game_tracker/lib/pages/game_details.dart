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
                  return [_deleteGame(), _editGame()];
                })
          ],
        ),
      body: Column(
        children: [
          _futureGameDetails(),
          Divider(
            thickness: 5,
            color: const Color.fromARGB(255, 96, 96, 96),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(
              "Reviews",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              )
            )
          ),
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

  PopupMenuEntry _editGame() {
    return PopupMenuItem(
      onTap: () {
        TextEditingController nameController = TextEditingController();
        TextEditingController descController = TextEditingController();
        DateTime newDate = DateTime.now();
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (context, StateSetter setDialogState) {
              return AlertDialog(
                  title: Text("Editando jogo"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          db
                              .updateGame(nameController.text, widget.userId,
                                  descController.text, newDate)
                              .then((_) => Navigator.pop(context));
                        },
                        child: Text("Aplicar")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar"))
                  ],
                  content: FutureBuilder(
                    future: db.getGames(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text("Um erro ocorreu");
                      }
                      if (snapshot.hasData) {
                        GameModel game = snapshot.data!.first;
                        nameController.text = game.name;
                        descController.text = game.description;
                        newDate = game.releaseDate;
                        return Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              TextField(
                                controller: nameController,
                                decoration:
                                    InputDecoration(label: Text("Nome")),
                                onChanged: (value) {
                                  nameController.text = value;
                                },
                              ),
                              TextField(
                                controller: descController,
                                decoration:
                                    InputDecoration(label: Text("Descrição")),
                                onChanged: (value) {
                                  nameController.text = value;
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ));
            });
          },
        );
      },
      child: Text("Editar Jogo"),
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
                    Divider(),
                    Text(
                      "Nota: ${snapshot.data![index].score}",
                      style: TextStyle(
                        fontSize: 11,
                      )
                    ),
                    Text(
                      snapshot.data![index].description,
                      style: TextStyle(
                        fontSize: 11,
                      )
                    ),
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
