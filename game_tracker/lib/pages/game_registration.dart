import 'package:flutter/material.dart';
import '../jsonmodels/game_model.dart';
import '../services/sqlite.dart';

class GameRegistAlertDialog extends StatefulWidget {
  int userId;
  Function updater;
  GameRegistAlertDialog(this.userId, this.updater, {super.key});

  @override
  State<GameRegistAlertDialog> createState() => _GameRegistAlertDialogState();
}

class _GameRegistAlertDialogState extends State<GameRegistAlertDialog> {
  DatabaseHelper db = DatabaseHelper();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController releaseDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Adicionar novo jogo"),
      content: Column(
        children: [
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Nome"),
            controller: nameController,
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Descrição"),
            controller: descriptionController,
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Data de lançamento"),
            controller: releaseDateController,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            nameController.clear();
            descriptionController.clear();
            releaseDateController.clear();

            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () async {
            var aux = releaseDateController.text.split("/");
            GameModel game = GameModel(
              userId: widget.userId,
              name: nameController.text,
              description: descriptionController.text,
              releaseDate: DateTime(
                  int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0])),
            );

            if (game.name.isEmpty ||
                game.description.isEmpty ||
                releaseDateController.text == "") {
              return;
            }

            List<GameModel> busca = await db.searchSpecificGame(game.name);
            var message = "";
            if (busca.isNotEmpty) {
              message = "Jogo já existente";
            } else {
              db.createGame(game);
              widget.updater();
              message = "Jogo criado com sucesso";
            }
            await showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      content: Text(message),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Ok"),
                        ),
                      ],
                    ),
                barrierDismissible: false);

            nameController.clear();
            descriptionController.clear();
            releaseDateController.clear();

            Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}
