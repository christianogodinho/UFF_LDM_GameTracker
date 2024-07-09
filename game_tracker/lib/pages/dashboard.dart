import 'package:game_tracker/jsonmodels/game_model.dart';
import 'package:game_tracker/jsonmodels/user_model.dart';
import 'package:game_tracker/services/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/views/dashboard_game.dart';

class Dashboard extends StatefulWidget {
  Users? user;
  Dashboard({super.key, this.user});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                // Se o usuário estiver logado, filtra pelo jogos cadastrados
                // Se não, mostra todos.
                var games = widget.user != null
                    ? snapshot.data!
                        .where((game) => game.userId == widget.user!.id)
                        .toList()
                    : snapshot.data;
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: games!.length),
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
