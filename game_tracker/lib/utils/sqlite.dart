import 'dart:math';
import 'package:game_tracker/models/game_genre_model.dart';
import 'package:game_tracker/models/game_model.dart';
import 'package:game_tracker/models/genre_model.dart';
import 'package:game_tracker/models/login_user_model.dart';
import 'package:game_tracker/models/review_model.dart';
import 'package:game_tracker/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "gametracker.db";
  //Script de criação do banco de dados
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

        INSERT INTO game(user_id, name, description, release_date) VALUES(2, 'Persona 5', 'transferido para a Academia Shujin, em Tóquio, Ren Amamiya está prestes a entrar no segundo ano do colegial. Após um certo incidente, sua Persona desperta, e junto com seus amigos eles formam os Ladrões-Fantasma de Corações, para roubar a fonte dos desejos deturpados dos adultos e assim reformar seus corações.', '2017-04-17');

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
  
  //Inicializa o banco de dados
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
            await db.execute(command);
          }
        }
      },
    );
  }

  //Buscar usuário por ID
  Future<List<Users>> getUserById(int id) async {
    final Database db = await initDB();

    List<Map<String, Object?>> result =
        await db.rawQuery("select * from user where id = ?", [id]);
    return result.map((e) => Users.fromMap(e)).toList();
  }

    //Logar usuário
  Future<List<Map<String, Object?>>> login(LoginUser user) async {
    final Database db = await initDB();

    var result = await db.rawQuery(
        "select * from user where email = '${user.email}' AND password = '${user.password}'");
    return result;
  }

  //Cadastrar usuário
  Future<int> signUp(Users user) async {
    final Database db = await initDB();

    var result =
        await db.rawQuery("select * from user where email = '${user.email}'");

    if (result.isEmpty) {
      return db.insert('user', user.toMap());
    } else {
      return 0;
    }
  }

  //Insere jogo
  Future<int> createGame(GameModel game) async {
    final Database db = await initDB();
    return db.insert('game', game.toMap());
  }

  //Retorna todos os jogos
  Future<List<GameModel>> getGames() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('game');
    var gameList = result.map((e) => GameModel.fromMap(e)).toList();
    for (var game in gameList) {
      game.averageScore = await getAverageReviews(game);
    }

    return gameList;
  }

  //Retorna a média das notas das reviews de um jogo
  Future<double> getAverageReviews(GameModel game) async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.rawQuery(
        "select AVG(review.score) from game left join review on game.id = review.game_id where game.id = ${game.id!};");
    var ret = result.first.values.first;
    if (ret != null) {
      return ret as double;
    }
    return 0;
  }

//Retorna jogos por gênero
  Future<List<GenreModel>> getGenres() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('genre');
    var genreList = result.map((e) => GenreModel.fromMap(e)).toList();
    for (var genre in genreList) {
      result = await db.query("game_genre",
          where: "game_genre.genre_id = ?", whereArgs: [genre.id!]);
      for (var item in result) {
        genre.gamesId.add(item["game_id"] as int);
      }
    }

    return genreList;
  }

  //Deletar jogo
  Future<int> deleteGame(int id) async {
    final Database db = await initDB();
    return db.delete('game', where: 'id = ?', whereArgs: [id]);
  }

  //Atualizar jogo
  Future<int> updateGame(
      title, userId, description, DateTime release_date, gameId) async {
    final Database db = await initDB();
    return db.rawUpdate(
        "update game set name = ?, user_id = ?, description = ?, release_date = ? where id = ?",
        [
          title,
          userId,
          description,
          "${release_date.year.toString().padLeft(4, '0')}-${release_date.month.toString().padLeft(2, '0')}-${release_date.day.toString().padLeft(2, '0')}",
          gameId
        ]);
  }

  Future<int> getGameId(String name) async {
    final Database db = await initDB();
    List<Map<String, Object?>> result =
        await db.rawQuery("select id from game where name = ?", [name]);
    return result.first["id"] as int;
  }

  //Buscar um jogo por parte do nome
  Future<List<GameModel>> searchGame(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult =
        await db.rawQuery("select * from game where name LIKE ?", [keyword]);

    return searchResult.map((e) => GameModel.fromMap(e)).toList();
  }

  //Buscar um jogo específico (nome exato)
  Future<List<GameModel>> searchSpecificGame(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult =
        await db.rawQuery('SELECT * from game WHERE name = ?', [keyword]);

    return searchResult.map((e) => GameModel.fromMap(e)).toList();
  }

  //Inserir Review
  Future<int> insertReview(ReviewModel review) async {
    final Database db = await initDB();
    return db.insert('review', review.toMap());
  }

  //Deletar Review
  Future<int> deleteReview(int id) async {
    final Database db = await initDB();
    return db.delete('review', where: 'id = ?', whereArgs: [id]);
  }

  //Buscar review por id
  Future<List<ReviewModel>> getReviewById(int id) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult =
        await db.rawQuery("select * from review where id = ?", [id]);

    return searchResult.map((e) => ReviewModel.fromMap(e)).toList();
  }

  //Buscar todas as reviews de um usuário
  Future<List<ReviewModel>> getReviewsByUser(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult =
        await db.rawQuery("select * from review where user_id = ?", [keyword]);

    return searchResult.map((e) => ReviewModel.fromMap(e)).toList();
  }

  //Buscar todas as reviews de um jogo
  Future<List<ReviewModel>> getReviewsByGame(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult =
        await db.rawQuery("select * from review where game_id = ? order by id DESC", [keyword]);

    return searchResult.map((e) => ReviewModel.fromMap(e)).toList();
  }

//Atualizar review
  Future<int> updateReview(id, userId, gameId, score, description, DateTime date) async {
    final Database db = await initDB();
    return db.rawUpdate(
      "update review set user_id = ?, game_id = ?, score = ?, description = ?, date = ? where id = ?",
      [
        userId,
        gameId,
        score,
        description,
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        id
      ]);
  }

//Deletar todas as reviews de um jogo
  Future<int> deleteAllGameReviews(int id) async {
    final Database db = await initDB();
    return db.delete('review', where: 'game_id = ?', whereArgs: [id]);
  }

  Future<List<GameGenreModel>> teste(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult =
        await db.rawQuery("select * from game_genre", [keyword]);

    return searchResult.map((e) => GameGenreModel.fromMap(e)).toList();
  }

  Future<int> editGameGenre(int gameId, List<bool> genreList) async {
    final Database db = await initDB();

    for(int i = 0; i < 8; i++){
      if(genreList[i] == true){
        List<GameGenreModel> busca = await searchGameGenre(gameId, i+1);
        if(busca.isEmpty){
          GameGenreModel gameGenre = GameGenreModel(
            gameId: gameId,
            genreId: i+1,
          );
          db.insert('game_genre', gameGenre.toMap());
        }
      }else{
        db.delete('game_genre',
            where: 'game_id = ? AND genre_id = ?', whereArgs: [gameId, i+1]);
      }
    }
    return 1;
  }

  Future<List<GameGenreModel>> searchGameGenre(gameId, genreId) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult =
        await db.rawQuery("select * from game_genre where game_id = ? and genre_id = ?", [gameId, genreId]);

    var res = searchResult.map((e) => GameGenreModel.fromMap(e)).toList();
    return res;
  }

  Future<int> removeGameGenre(int gameId, int genreId) async {
    final Database db = await initDB();
    return db.delete('game_genre',
        where: 'game_id = ? AND genre_id = ?', whereArgs: [gameId, genreId]);
  }

  Future<List<GenreModel>> getAllGenres() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.rawQuery(
        "select * from genre");
    return result.map((e) => GenreModel.fromMap(e)).toList();
  }

  Future<List<int>> getGameGenresId(int gameId) async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.rawQuery(
        "select genre_id from game_genre where game_id = ?", [gameId]);
    return result.map((e) => e["genre_id"] as int).toList();
  }

  Future<List<String>> getGameGenresByGameId(int gameId) async {
    final Database db = await initDB();
    List<int> genreIds = await getGameGenresId(gameId);
    print(genreIds);
    List<Map<String, Object?>> result = [];
    for(int genre in genreIds){
      var aux = await db.rawQuery("select name from genre where id = ?", [genre]);
      result.add(aux.first);
    }
    return result.map((e) => e["name"] as String).toList();
  }

  Future<List<bool>> getGameGenresIdList(int gameId, List<bool> genresList) async{
    final db = await initDB();
    List<Map<String, Object?>> result = await db.rawQuery("select genre_id from game_genre where game_id = ?", [gameId]);
    List<int> aux = result.map((e) => e["genre_id"] as int).toList();
    
    for(int i in aux){
      genresList[i-1] = true;
    }

    return genresList;
  }
}

