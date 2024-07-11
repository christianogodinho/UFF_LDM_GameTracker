import 'package:flutter/material.dart';
import '../jsonmodels/game_model.dart';
import '../services/sqlite.dart';

class detailsScreen extends StatefulWidget {
  String gameName;
  
  detailsScreen(this.gameName, {super.key});

  @override
  State<detailsScreen> createState() => _detailsScreenState();
}

class _detailsScreenState extends State<detailsScreen> {

  DatabaseHelper db = DatabaseHelper();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _futureGameDetails(),
          ],
        ),
      ),
    );
  }

  FutureBuilder _futureGameDetails() {
    Future<List<GameModel>> games = db.getGames();
    return FutureBuilder(
      future: games,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Text(snapshot.data.name),
                Text(snapshot.data.description),
                Text(snapshot.data.releaseDate),
              ],
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

  FutureBuilder _futureGameReviews(){
    
    Future<List<GameModel>> reviews = db.getGames();
    return FutureBuilder(
      future: reviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Column(
              children: [
                
              ],
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
}
