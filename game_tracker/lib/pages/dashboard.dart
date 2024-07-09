import 'package:game_tracker/jsonmodels/game_model.dart';
import 'package:game_tracker/jsonmodels/user_model.dart';
import 'package:game_tracker/services/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/views/dashboard_game.dart';

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
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_alt),
            tooltip: "Filtar jogos",
          )
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      return DashboardGame(games[index]);
                    });
              } else {
                return CircularProgressIndicator();
              }
            },
          )),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text("Deslogar"),
            ),
            ListTile(
              title: Text("Reviews Recentes"),
            )
          ],
        ),
      ),
      floatingActionButton: widget.user == null
          ? null
          : FloatingActionButton(
              onPressed: () {},
              tooltip: "Criar um novo jogo",
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            ),
    );
  }
}
