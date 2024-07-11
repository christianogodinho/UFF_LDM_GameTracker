// To parse this JSON data, do
//
//     final game = gameFromMap(jsonString);

import 'dart:convert';

ReviewModel gamemodelFromMap(String str) => ReviewModel.fromMap(json.decode(str));

String gamemodelToMap(ReviewModel data) => json.encode(data.toMap());

class ReviewModel {
    final int? id;
    final int userId;
    final int gameId;
    final double score;
    final String description;
    final DateTime date;

    ReviewModel({
        this.id,
        required this.userId,
        required this.gameId,
        required this.score,
        required this.description,
        required this.date,
    });

    factory ReviewModel.fromMap(Map<String, dynamic> json) => ReviewModel(
        id: json["id"],
        userId: json["user_id"],
        gameId: json["game_id"],
        score: json["score"],
        description: json["description"],
        date: DateTime.parse(json["date"]),

    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "user_id": userId,
        "gameId": gameId,
        "description": description,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    };
}
