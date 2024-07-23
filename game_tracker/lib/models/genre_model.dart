import 'dart:convert';

GenreModel genremodelFromMap(String str) =>
    GenreModel.fromMap(json.decode(str));

String genremodelToMap(GenreModel data) => json.encode(data.toMap());

class GenreModel {
  final int? id;
  final String name;
  List<int> gamesId = [];

  GenreModel({
    this.id,
    required this.name,
  });

  factory GenreModel.fromMap(Map<String, dynamic> json) => GenreModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
      };
}
