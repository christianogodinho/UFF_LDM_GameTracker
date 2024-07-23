import 'package:game_tracker/models/game_model.dart';

//Retorna a data de lançamento do jogo no formato dd/mm/yyyy
String getReleaseDate(GameModel game) {
    return "${game.releaseDate.day}/${game.releaseDate.month}/${game.releaseDate.year}";
  }