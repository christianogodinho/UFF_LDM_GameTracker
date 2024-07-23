import 'package:flutter/material.dart';
import 'package:game_tracker/models/game_genre_model.dart';
import 'package:game_tracker/models/game_model.dart';
import 'package:game_tracker/utils/sqlite.dart';
import 'package:game_tracker/view/dialogs/genre_selection_dialog.dart';

//Cria o diálogo de registro de jogo
class GameRegistrationDialog extends StatefulWidget {
  int userId;
  Function updateAncestor;
  GameRegistrationDialog(this.userId, this.updateAncestor, {super.key});

  List<bool> gendersList = [false, false, false, false, false, false, false, false];

  @override
  State<GameRegistrationDialog> createState() => _GameRegistrationDialogState();
}

class _GameRegistrationDialogState extends State<GameRegistrationDialog> {
  DatabaseHelper db = DatabaseHelper();
  bool erro = false;

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
          _GenreSelection(),
          Visibility(
            visible: erro,
            child: Text("Preencha todos os campos",
              style: TextStyle(color: Colors.red)
            )
          )
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
            if (nameController.text == "" || descriptionController.text == "" || releaseDateController.text == ""){
              setState(() {
                erro = true;
              });
              return;
            }

            if(widget.gendersList.every((element) => element == false)){
              setState(() {
                erro = true;
              });
              return;
            }
            
            var aux = releaseDateController.text.split("/");
            GameModel game = GameModel(
              userId: widget.userId,
              name: nameController.text,
              description: descriptionController.text,
              releaseDate: DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0])),
            );


            //Checa se o jogo já existe
            List<GameModel> busca = await db.searchSpecificGame(game.name);
            var message = "";

            if (busca.isEmpty){
              await db.createGame(game).then((value) => db.editGameGenre(value, widget.gendersList));        
              message = "Jogo criado com sucesso";
            }else{
              message = "Jogo já existente";
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
            widget.updateAncestor();
            Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }

  TextButton _GenreSelection() {
    return TextButton(
      child: const Text("Clique aqui para selecionar os gêneros"),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) => GenreSelectionDialog(widget.gendersList),
        );
      },
    );
  }


}
