import 'package:game_tracker/jsonmodels/game_model.dart';
import 'package:game_tracker/jsonmodels/genre_model.dart';
import 'package:game_tracker/jsonmodels/user_model.dart';
import 'package:game_tracker/services/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/views/dashboard_game.dart';

import 'game_registration.dart';

class Dashboard extends StatefulWidget {
  final Users? user;

  Dashboard({super.key, this.user});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool filterByUser(GameModel game) {
    // Se o usuário estiver logado, filtra pelo jogos cadastrados
    // Se não, mostra todos.
    if (widget.user != null) {
      return widget.user!.id == game.userId;
    }
    return true;
  }

  bool Function(GameModel)? currentFilter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 21, 22),
      appBar: AppBar(
        title: Text("GameTracker - Dashboard"),
        // Seleção de filtros
        actions: [
          PopupMenuButton(
              icon: Icon(Icons.filter_alt),
              itemBuilder: (context) {
                return [
                  // Filtro de data de lançamento
                  PopupMenuItem(
                    child: Text("Data de Lançamento"),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            DateTime? dateToFilter;
                            var choice = "";
                            return StatefulBuilder(
                                builder: (context, StateSetter setDialogState) {
                              return AlertDialog(
                                title: Text("Filtrar por data de lançamento"),
                                content: Column(
                                  children: [
                                    Column(
                                      children: [
                                        RadioListTile(
                                          title: const Text("Antes de:"),
                                          value: "antes",
                                          groupValue: choice,
                                          onChanged: (value) =>
                                              setDialogState(() {
                                            choice = value.toString();
                                          }),
                                        ),
                                        RadioListTile(
                                          title: const Text("Depois de:"),
                                          value: "depois",
                                          groupValue: choice,
                                          onChanged: (value) =>
                                              setDialogState(() {
                                            choice = value.toString();
                                          }),
                                        )
                                      ],
                                    ),
                                    InputDatePickerFormField(
                                        firstDate: DateTime(1958),
                                        lastDate: DateTime.now(),
                                        onDateSubmitted: (value) =>
                                            setDialogState(
                                                () => dateToFilter = value)),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        print(dateToFilter);
                                        print(choice);
                                        setState(
                                          () {
                                            currentFilter = (GameModel game) {
                                              if (choice == "antes") {
                                                return game.releaseDate
                                                    .isBefore(dateToFilter!);
                                              }
                                              return game.releaseDate
                                                  .isAfter(dateToFilter!);
                                            };
                                          },
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Aplicar")),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancelar"))
                                ],
                              );
                            });
                          });
                    },
                  ),
                  // Filtrar por gênero
                  PopupMenuItem(
                      child: const Text("Gênero"),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              var menuChoice;
                              GenreModel? selectedGenre;
                              return StatefulBuilder(
                                builder: (context, StateSetter setDialogState) {
                                  return AlertDialog(
                                    title: const Text("Filtrar por Gênero"),
                                    content: FutureBuilder(
                                        future: DatabaseHelper().getGenres(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return const Text(
                                                "Erro ao recuperar lista de gêneros");
                                          } else if (snapshot.hasData) {
                                            return DropdownButtonFormField(
                                                items: snapshot.data!
                                                    .map((e) =>
                                                        DropdownMenuItem(
                                                          child: Text(e.name),
                                                          value: e.id,
                                                        ))
                                                    .toList(),
                                                value: menuChoice,
                                                onChanged: (genre) {
                                                  menuChoice = genre;
                                                  selectedGenre = snapshot.data!
                                                      .firstWhere((g) =>
                                                          g.id == menuChoice);
                                                  setDialogState(() {});
                                                });
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        }),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            print(menuChoice);
                                            print(selectedGenre);
                                            setState(
                                              () {
                                                currentFilter =
                                                    (GameModel game) {
                                                  if (selectedGenre != null) {
                                                    return selectedGenre!
                                                        .gamesId
                                                        .contains(game.id);
                                                  }
                                                  return true;
                                                };
                                              },
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Aplicar")),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancelar"))
                                    ],
                                  );
                                },
                              );
                            });
                      }),
                  PopupMenuItem(
                    child: Text("Nota da Review"),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            double nota = 5;
                            return StatefulBuilder(
                                builder: (context, StateSetter setDialogState) {
                              return AlertDialog(
                                title: Text("Filtrar por nota"),
                                content: Slider(
                                    value: nota,
                                    max: 10.0,
                                    label: "$nota",
                                    divisions: 20,
                                    onChanged: (novaNota) {
                                      setDialogState(() => nota = novaNota);
                                    }),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        setState(
                                          () {
                                            currentFilter = (GameModel game) {
                                              return game.averageScore >= nota;
                                            };
                                          },
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Aplicar")),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Cancelar"))
                                ],
                              );
                            });
                          });
                    },
                  )
                ];
              }),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<List<GameModel>>(
            future: DatabaseHelper().getGames(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(
                    "Erro ao recuperar jogos do banco de dados.\n${snapshot.error}");
              } else if (snapshot.hasData) {
                if (currentFilter == null) {
                  currentFilter = filterByUser;
                }
                var games = snapshot.data!.where(currentFilter!).toList();
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      return DashboardGame(games[index]);
                    });
              } else {
                return const CircularProgressIndicator();
              }
            },
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () {
            showDialog(
                context: context,
                builder: (builder) {
                  return GameRegistAlertDialog(1);
                });
          },
          child: Icon(Icons.add)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text("Deslogar"),
            ),
            ListTile(
              title: const Text("Reviews Recentes"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  currentFilter = (GameModel game) {
                    return true;
                  };
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
