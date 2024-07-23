import 'package:flutter/material.dart';
import 'package:game_tracker/models/game_genre_model.dart';
import 'package:game_tracker/models/game_model.dart';
import 'package:game_tracker/models/review_model.dart';
import 'package:game_tracker/utils/all_utils.dart';
import 'package:game_tracker/view/dialogs/genre_selection_dialog.dart';
import 'package:game_tracker/view/dialogs/review_registration.dart';

const Color defaultTextColor = Color.fromARGB(255, 244, 242, 235);
const String defaultFontFamily = "Noto Sans";

class GameDetails extends StatefulWidget {
  int gameId;
  int? userId;
  String gameName;
  Function updateDashboard;

  GameDetails(this.gameId, this.gameName, this.userId, this.updateDashboard, {super.key});
  List<bool> genresList = List.filled(8, false);

  @override
  State<GameDetails> createState() => _GameDetailsState();
}

class _GameDetailsState extends State<GameDetails> {

  void updater(){
    setState(() {});
  }

  DatabaseHelper db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 21, 22),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 101, 153, 255),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              widget.updateDashboard();
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            "Detalhes do Jogo",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          actions: [
            PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [_editGame(), _deleteGame()];
                })
          ],
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _futureGameDetails(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Divider(
              thickness: 0.5,
              color: Colors.blueGrey,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 0, 20),
            child: Text(
              "Reviews",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: defaultTextColor,
              )
            ),
          ),
          _futureGameReviews(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: widget.userId != null,
        child: SizedBox(
          height: 50,
          width: 130,
          child: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 101, 153, 255),
            onPressed: () {
              showDialog(
                context: context,
                builder: (builder) {
                  return ReviewRegistrationDialog(widget.gameId, widget.userId!, widget.gameName, updater);
                }
              );
            },
            child: Text("Adicionar Review"),
          ),
        )
      )
    );
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
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      fontFamily: defaultFontFamily,
                      color: Color.fromARGB(255, 244, 242, 235)
                    ),
                  ),
                  Text(
                    "Lançado em ${getReleaseDate(game)}",
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: defaultFontFamily,
                      color: Color.fromARGB(255, 244, 242, 235)
                    ),
                  ),
                  _buildGameGenresList(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Divider(
                      color: Colors.blueGrey,
                      thickness: 0.5,
                    ),
                  ),
                  Text(
                    game.description,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: defaultFontFamily,
                      color: defaultTextColor
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Text(
              "Erro ao carregar dados",
              style: TextStyle(
                fontFamily: defaultFontFamily,
                color: defaultTextColor
              )
            );
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _futureUsername(snapshot.data[index].userId!),
                                Text(
                                  "Nota: ${snapshot.data![index].score}",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: defaultFontFamily,
                                    color: defaultTextColor
                                  )
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: SizedBox(
                                    width: 270,
                                    child: Text(
                                      snapshot.data![index].description,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontFamily: defaultFontFamily,
                                        color: defaultTextColor
                                      )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _isReviewFromUser(snapshot, index),
                            child: PopupMenuButton(
                              icon: Icon(
                                Icons.more_vert,
                                color: defaultTextColor,
                                ),
                              itemBuilder: (context) => [_editReview(snapshot.data![index]), _deleteReview(snapshot.data![index])],
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Divider(
                          color: Colors.blueGrey,
                          thickness: 0.5
                        ),
                      ),
                    ],
                  );
                },
              )
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

  PopupMenuEntry _editGame() {
    return PopupMenuItem(
      onTap: () {
        TextEditingController nameController = TextEditingController();
        TextEditingController descController = TextEditingController();
        TextEditingController releaseDateController = TextEditingController();

        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (context, StateSetter setDialogState) {
              return AlertDialog(
                  title: Text("Editando jogo"),
                  content: FutureBuilder(
                    future: db.searchSpecificGame(widget.gameName),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Um erro ocorreu");
                      }
                      if (snapshot.hasData) {
                        GameModel game = snapshot.data!.first;
                        nameController.text = game.name;
                        descController.text = game.description;
                        releaseDateController.text = getReleaseDate(game);

                        return Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              TextField(
                                keyboardType: TextInputType.text,
                                controller: nameController,
                                decoration: InputDecoration(label: Text("Nome")),
                                onChanged: (value) {
                                  nameController.text = value;
                                },
                              ),
                              TextField(
                                keyboardType: TextInputType.text,
                                controller: descController,
                                decoration: InputDecoration(label: Text("Descrição")),
                                onChanged: (value) {
                                  descController.text = value;
                                },
                              ),
                              TextField(
                                keyboardType: TextInputType.text,
                                controller: releaseDateController,
                                decoration: InputDecoration(label: Text("Data de Lançamento")),
                                onChanged: (value) {
                                  releaseDateController.text = value;
                                },
                              ),
                              _EditGenreSelection(widget.genresList),
                            ],
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          
                          db.editGameGenre(widget.gameId, widget.genresList);
                          updater();
                          
                          var aux = releaseDateController.text.split("/");
                          DateTime newDate = DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));
                          db.updateGame(nameController.text, widget.userId,descController.text, newDate, widget.gameId)
                            .then((_) {
                              updater();
                              Navigator.pop(context);
                            }
                          );
                          
                        },
                        child: Text("Aplicar")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar"))
                  ],
                );
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
                  title: Text("Aviso"),
                  content: Text("Deseja mesmo remover este jogo?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Sai do dialogo
                          Navigator.pop(context);
                          db.deleteAllGameReviews(widget.gameId); // Sai dos detalhes
                          db.deleteGame(widget.gameId);
                          widget.updateDashboard();
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

  PopupMenuEntry _editReview(ReviewModel review) {
    return PopupMenuItem(
      onTap: () {
        TextEditingController descriptionController = TextEditingController();
        double score = 0.0;
        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, StateSetter setDialogState) {
              return AlertDialog(
                  title: Text("Editando review"),
                  content: FutureBuilder(
                    future: db.getReviewById(review.id!),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Um erro ocorreu");
                      }
                      if (snapshot.hasData) {

                        ReviewModel review = snapshot.data!.first;
                        descriptionController.text = review.description;
                        score = review.score;

                        return Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text("Nota"),
                              Slider(
                                value: score,
                                max: 10.0,
                                label: "$score",
                                divisions: 20,
                                onChanged: (newScore) {
                                  setState(() {
                                    score = newScore;
                                  }
                                );
                              }),
                              TextField(
                                controller: descriptionController,
                                decoration:
                                    InputDecoration(label: Text("Descrição")),
                                onChanged: (newDescription) {
                                  descriptionController.text = newDescription;
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          db.updateReview(review.id!, review.userId, widget.gameId, score, descriptionController.text, DateTime.now())
                              .then((_) => Navigator.pop(context));
                        },
                        child: Text("Aplicar")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancelar"))
                  ],
                );
            });
          },
        );
      },
      child: Text("Editar Review"),
    );
  }

  PopupMenuEntry _deleteReview(ReviewModel review) {
    return PopupMenuItem(
        onTap: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Aviso"),
                  content: Text("Deseja mesmo remover esta review?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          db.deleteReview(review.id!);
                          updater();
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
        child: Text("Deletar Review"));
  }

  bool _isReviewFromUser(AsyncSnapshot<dynamic> snapshot, int index) {
    return snapshot.data![index].userId == widget.userId;
  }

  FutureBuilder _futureUsername(int userId){
    return FutureBuilder(
      future: db.getUserById(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data!.first.name,
              style: TextStyle(
                fontSize: 12,
                fontFamily: defaultFontFamily,
                color: defaultTextColor
              )
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

  FutureBuilder _buildGameGenresList() {
    return FutureBuilder(
      future: db.getGameGenresByGameId(widget.gameId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Wrap(
              children: 
                List.generate(
                  snapshot.data!.length,
                  (index){
                    return Padding(
                      padding: EdgeInsets.fromLTRB(3, 6, 3, 3),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Color.fromARGB(255, 101, 153, 255),
                        ),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
                          child: Text(
                            snapshot.data![index],
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: defaultFontFamily,
                              color: defaultTextColor,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                      ),
                    );
                  }
                )
              ,
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

  TextButton _EditGenreSelection(List<bool> genresList) {
    return TextButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_){
            return FutureBuilder(
              future: db.getGameGenresIdList(widget.gameId, genresList),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData){
                    return GenreSelectionDialog(snapshot.data!);
                  }
                return const CircularProgressIndicator();
                }
              return const Text("Erro ao carregar dados");
              }
            );
          } 
        );
      },
      child: Text("Clique aqui para selecionar os gêneros")
    );
  }
}
