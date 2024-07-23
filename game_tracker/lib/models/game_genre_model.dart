import 'dart:convert';

GameGenreModel gameGenremodelFromMap(String str) =>
    GameGenreModel.fromMap(json.decode(str));

String gameGenremodelToMap(GameGenreModel data) => json.encode(data.toMap());

class GameGenreModel {
  final int? gameId;
  final int? genreId;

  GameGenreModel({
    this.gameId,
    this.genreId,
  });

  factory GameGenreModel.fromMap(Map<String, dynamic> json) => GameGenreModel(
        gameId: json["game_id"],
        genreId: json["genre_id"],
      );

  Map<String, dynamic> toMap() => {
        "game_id": gameId,
        "genre_id": genreId,
      };
}
