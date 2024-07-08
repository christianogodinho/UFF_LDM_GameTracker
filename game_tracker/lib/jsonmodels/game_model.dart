// To parse this JSON data, do
//
//     final game = gameFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GameModel gamemodelFromMap(String str) => GameModel.fromMap(json.decode(str));

String gamemodelToMap(GameModel data) => json.encode(data.toMap());

class GameModel {
    final int? id;
    final int userId;
    final String name;
    final String description;
    final DateTime releaseDate;

    GameModel({
        this.id,
        required this.userId,
        required this.name,
        required this.description,
        required this.releaseDate,
    });

    factory GameModel.fromMap(Map<String, dynamic> json) => GameModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        description: json["description"],
        releaseDate: DateTime.parse(json["release_date"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "description": description,
        "release_date": "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
    };
}
