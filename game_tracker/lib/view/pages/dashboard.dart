import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game_tracker/models/all_models.dart';
import 'package:game_tracker/utils/all_utils.dart';
import 'package:game_tracker/view/pages/game_details.dart';
import 'package:game_tracker/authentication/login.dart';
import 'package:game_tracker/view/dialogs/game_registration.dart';

class Dashboard extends StatefulWidget {
  final Users? user;
  String menu = "Todos os jogos";

  Dashboard({super.key, this.user});

  @override
  State<Dashboard> createState() => _DashboardState();

  bool Function(GameModel)? currentFilter;
  String? choice = "";
  TextEditingController? dateController = TextEditingController();
  DateTime? dateToFilter;
}

class _DashboardState extends State<Dashboard> {

  void updater() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 34, 21, 22),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 101, 153, 255),
        centerTitle: true,
        title: Text(
            "GameTracker - Dashboard",
            style: TextStyle(
              fontSize: 18,
            )
          ),
        actions: [
          filterSelectionMenu()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.menu,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Noto Sans',
                  color: Color.fromARGB(255, 244, 242, 235)
                )
              ),
            ),
            Expanded(child: createGameCardsList()),
          ],
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: widget.user != null,
        child: SizedBox(
          height: 50,
          width: 120,
          child: FloatingActionButton(
            backgroundColor: Color.fromARGB(255, 101, 153, 255),
            onPressed: () {

              showDialog(
                context: context,
                builder: (builder) {
                  return GameRegistrationDialog(widget.user!.id!, updater);
                }
              );
            },
          child: Text("Adicionar jogo"),
          ),
        )
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text("Deslogar"),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
            ListTile(
              title: const Text("Todos os jogos"),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  widget.menu = "Todos os jogos";
                  widget.currentFilter = (GameModel game) {
                    return true;
                  };
                });
              },
            ),
            Visibility(
              visible: widget.user != null,
              child: ListTile(
                title: Text("Meus jogos"),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    widget.menu = "Meus jogos";
                    widget.currentFilter = filterByUser;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }


  PopupMenuButton filterSelectionMenu(){
    return PopupMenuButton(
      icon: Icon(Icons.filter_alt),
      itemBuilder: (context) {
        return [
          filterByLaunchDate(),
          filterByGenre(),
          filterByScore()
        ];
      });
  }

  bool filterByUser(GameModel game) {
    // Se o usuário estiver logado, filtra pelo jogos cadastrados
    // Se não, mostra todos.
    if (widget.user != null) {
      widget.menu = "Todos os jogos";
      return widget.user!.id == game.userId;
    }
    widget.menu = "Meus jogos";
    return true;
  }

  PopupMenuItem filterByLaunchDate(){
    return PopupMenuItem(
      child: Text("Data de Lançamento"),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
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
                            groupValue: widget.choice,
                            onChanged: (String? value){
                              setDialogState(() {widget.choice = value;});
                            }
                          ),
                          RadioListTile(
                            title: const Text("Depois de:"),
                            value: "depois",
                            groupValue: widget.choice,
                            onChanged: (String? value){
                              setDialogState(() {widget.choice = value;});
                            }
                          ),
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: "Data (dd/mm/aaaa)"),
                        controller: widget.dateController,
                        onChanged: (value) {
                          var aux = value.split("/");
                          if (aux.length == 3) {
                            widget.dateToFilter = DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0]));
                          }
                        },
                        keyboardType: TextInputType.text,
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        print(widget.dateToFilter);
                        if (widget.dateToFilter == null) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                    "Insira uma data válida! Lembre-se de confirmar a entrada e separar dia, mês e ano por \"/\"!"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Ok"))
                                ],
                              );
                            });
                          return;
                        }
                        setState(() {
                          widget.currentFilter = (GameModel game) {
                            if (widget.choice == "antes") {
                              return game.releaseDate.isBefore(widget.dateToFilter!);
                            }
                            return game.releaseDate.isAfter(widget.dateToFilter!);
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
              }
            );
          }
        );
      },
    );
  }

  PopupMenuItem filterByGenre(){
    return PopupMenuItem(
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
                          return const Text("Erro ao recuperar lista de gêneros");
                        } else if (snapshot.hasData) {
                          return DropdownButtonFormField(
                            items: snapshot.data!
                              .map((e) =>
                                  DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.name)
                                  ))
                              .toList(),
                            value: menuChoice,
                            onChanged: (genre) {
                              menuChoice = genre;
                              selectedGenre = snapshot.data!.firstWhere((g) => g.id == menuChoice);
                              setDialogState(() {});
                            }
                          );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }
                  ),
                  actions: [
                    TextButton(
                      child: const Text("Aplicar"),
                      onPressed: () {
                        setState(() {
                          widget.currentFilter = (GameModel game) {
                            if (selectedGenre != null) {
                              return selectedGenre!.gamesId.contains(game.id);
                            }
                            return true;
                          };
                        });
                        Navigator.pop(context);
                      },
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: const Text("Cancelar")
                    )
                  ],
                );
              },
            );
          }
        );
      }
    );
  }

  PopupMenuItem filterByScore(){
    return PopupMenuItem(
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
                }
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                        widget.currentFilter = (GameModel game) {
                          return game.averageScore >= nota;
                        };
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Aplicar")),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar")
                )
              ],
            );
          });
        });
      },
    );
  }

  GestureDetector createGameCard(GameModel game, int? userId){
    return GestureDetector(
      child: Card(
          color: Color.fromARGB(255, 255, 239, 212),
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.name,
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      getReleaseDate(game),
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    )
                  ],
                ),
                Text(
                  "Média: ${game.averageScore.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ],
            )
          ),
        ),
      onTap: () {
        //Vai para a tela de detalhes do jogo caso o card seja tocado
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetails(game.id!, game.name, userId, updater),
          ),
        );
      },
    );
  }

  FutureBuilder<List<GameModel>> createGameCardsList(){
    return FutureBuilder<List<GameModel>>(
      future: DatabaseHelper().getGames(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Erro ao recuperar jogos do banco de dados.\n${snapshot.error}");
        } else if (snapshot.hasData) {
          List<GameModel> games = [];
          if(widget.currentFilter == null) {
            games = snapshot.data!.toList();
          } else {
            games = snapshot.data!.where(widget.currentFilter!).toList();
          }
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              return createGameCard(games[index], widget.user?.id);
            }
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
