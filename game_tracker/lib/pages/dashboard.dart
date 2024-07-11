import 'package:game_tracker/jsonmodels/game_model.dart';
import 'package:game_tracker/services/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:game_tracker/views/dashboard_game.dart';

import 'game_registration.dart';

class Dashboard extends StatefulWidget {
  final bool isUserLogged;
  int? userId;
  Dashboard(this.isUserLogged, {super.key, this.userId});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GameTracker - Dashboard"),
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
                var games = widget.isUserLogged
                    ? snapshot.data!
                        .where((game) => game.userId == widget.userId)
                        .toList()
                    : snapshot.data;
                return ListView.builder(
                    itemCount: games!.length,
                    itemBuilder: (context, index) {
                      return DashboardGame(games[index]);
                    });
              } else {
                return CircularProgressIndicator();
              }
            },
          )
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          showDialog(
            context: context,
            builder: (builder){
              return GameRegistAlertDialog(1);
            }
          );
        },
        child: Icon(Icons.add)
      )
    );
  }
}
