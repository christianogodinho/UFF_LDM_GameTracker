import 'package:game_tracker/jsonmodels/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../jsonmodels/game_model.dart';

class DatabaseHelper {
  final databaseName = "gametracker.db";
  String create_script = '''
        CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR NOT NULL,
        email VARCHAR NOT NULL,
        password VARCHAR NOT NULL
        );

        INSERT INTO user(name, email, password) VALUES('Teste 1', 'teste1@teste', '123456');
        INSERT INTO user(name, email, password) VALUES('Teste 2', 'teste2@teste', '123456');
        INSERT INTO user(name, email, password) VALUES('Teste 3', 'teste3@teste', '123456');
        INSERT INTO user(name, email, password) VALUES('Teste 4', 'teste4@teste', '123456');
        INSERT INTO user(name, email, password) VALUES('Teste 5', 'teste5@teste', '123456');

        CREATE TABLE genre(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR NOT NULL
        );

        INSERT INTO genre(name) VALUES('Aventura');
        INSERT INTO genre(name) VALUES('Ação');
        INSERT INTO genre(name) VALUES('RPG');
        INSERT INTO genre(name) VALUES('Plataforma');
        INSERT INTO genre(name) VALUES('Metroidvania');
        INSERT INTO genre(name) VALUES('Rogue Lite');
        INSERT INTO genre(name) VALUES('Survival Horror');
        INSERT INTO genre(name) VALUES('Mundo Aberto');

        CREATE TABLE game(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            name VARCHAR NOT NULL UNIQUE,
            description TEXT NOT NULL,
            release_date VARCHAR NOT NULL,
            FOREIGN KEY(user_id) REFERENCES user(id)
        );

        INSERT INTO game(user_id, name, description, release_date) VALUES(1, 'God of War', 'O jogo começa após a morte da segunda esposa de Kratos e mãe de Atreus, Faye. Seu último desejo era que suas cinzas fossem espalhadas no pico mais alto dos nove reinos nórdicos. Antes de iniciar sua jornada, Kratos é confrontado por um homem misterioso com poderes divinos.', '2018-04-18');

        INSERT INTO game(user_id, name, description, release_date) VALUES(1, 'Resident Evil 4', 'Resident Evil 4 é um jogo de terror e sobrevivência no qual os jogadores terão que enfrentar situações extremas de medo. Apesar dos vários elementos de terror, o jogo é equilibrado com muita ação e uma experiência de jogo bastante variada.', '2023-03-24');

        INSERT INTO game(user_id, name, description, release_date) VALUES(2, 'Persona 5', 'ransferido para a Academia Shujin, em Tóquio, Ren Amamiya está prestes a entrar no segundo ano do colegial. Após um certo incidente, sua Persona desperta, e junto com seus amigos eles formam os Ladrões-Fantasma de Corações, para roubar a fonte dos desejos deturpados dos adultos e assim reformar seus corações.', '2017-04-17');

        INSERT INTO game(user_id, name, description, release_date) VALUES(3, 'Horizon Zero Dawn', 'Horizon Zero Dawn é um RPG eletrônico de ação em que os jogadores controlam a protagonista Aloy, uma caçadora e arqueira, em um cenário futurista, um mundo aberto pós-apocalíptico dominado por criaturas mecanizadas como robôs dinossauros.', '2017-02-28');

        CREATE TABLE game_genre(
            game_id INTEGER NOT NULL,
            genre_id INTEGER NOT NULL,
            FOREIGN KEY(game_id) REFERENCES game(id),
            FOREIGN KEY(genre_id) REFERENCES genre(id)
        );

        INSERT INTO game_genre(game_id, genre_id) VALUES(1, 1);
        INSERT INTO game_genre(game_id, genre_id) VALUES(2, 7);
        INSERT INTO game_genre(game_id, genre_id) VALUES(3, 3);
        INSERT INTO game_genre(game_id, genre_id) VALUES(4, 2);
        INSERT INTO game_genre(game_id, genre_id) VALUES(4, 3);
        INSERT INTO game_genre(game_id, genre_id) VALUES(4, 8);

        CREATE TABLE review(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            game_id INTEGER NOT NULL,
            score REAL NOT NULL,
            description TEXT,
            date VARCHAR NOT NULL,
            FOREIGN KEY(user_id) REFERENCES user(id),
            FOREIGN KEY(game_id) REFERENCES game(id)
        );

        INSERT INTO review(user_id, game_id, score, description, date) VALUES(1, 1, 9.5, 'Teste', '2024-06-20');
        INSERT INTO review(user_id, game_id, score, description, date) VALUES(2, 1, 9.0, 'Teste', '2024-06-20');
        INSERT INTO review(user_id, game_id, score, description, date) VALUES(3, 1, 8.5, 'Teste', '2024-06-20');
        INSERT INTO review(user_id, game_id, score, description, date) VALUES(4, 1, 9.6, 'Teste', '2024-06-20');
  ''';

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    var commands = create_script.split(";");

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        for (String command in commands) {
          command = command.trim();
          if (command.isNotEmpty && command != " ") {
            command = "$command;";
            print(command);
            await db.execute(command);
          }
        }
      },
    );
  }

  //Create Game
  Future<int> createGame(GameModel game) async {
    final Database db = await initDB();
    return db.insert('game', game.toMap());
  }

  //Get Game
  Future<List<GameModel>> getGames() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('game');
    return result.map((e) => GameModel.fromMap(e)).toList();
  }

  //Delete Game
  Future<int> deleteGame(int id) async {
    final Database db = await initDB();
    return db.delete('game', where: 'id = ?', whereArgs: [id]);
  }

  //Update Game
  Future<int> updateGame(title, user_id, description, release_date) async {
    final Database db = await initDB();
    return db.rawUpdate(
        "update game set nome = ?, user_id = ?, description = ?, release_date = ?",
        [title, user_id, description, release_date]);
  }

  //Search Game
  Future<List<GameModel>> searchGame(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db
        .rawQuery("select * from game where name LIKE ?", ["%$keyword"]);

    return searchResult.map((e) => GameModel.fromMap(e)).toList();
  }

  //Login
  Future<bool> login(Users user) async {
    final Database db = await initDB();

    var result = await db.rawQuery(
        "select * from user where name = '${user.name}' AND password = '${user.password}'");

    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  //Sign up
  Future<int> signUp(Users user) async {
    final Database db = await initDB();

    var result =
        await db.rawQuery("select * from user where name = '${user.name}'");

    if (result.isEmpty) {
      return db.insert('user', user.toMap());
    } else {
      return 0;
    }
  }
}
