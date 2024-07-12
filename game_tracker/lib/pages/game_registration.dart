import 'package:flutter/material.dart';
import '../jsonmodels/game_model.dart';
import '../services/sqlite.dart';

class GameRegistAlertDialog extends StatefulWidget {
  
  int userId;
  GameRegistAlertDialog(this.userId,{super.key});


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
          onPressed: () async{
            var aux = releaseDateController.text.split("/");
            GameModel game = GameModel(
              userId: widget.userId,
              name: nameController.text,
              description: descriptionController.text,
              releaseDate: DateTime(int.parse(aux[2]), int.parse(aux[1]), int.parse(aux[0])),
            );

            if(game.name.isEmpty || game.description.isEmpty || releaseDateController.text == ""){
              return;
            }

            Future<List<GameModel>> busca = db.searchSpecificGame(game.name);

            await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: FutureBuilder(
                  future: busca,
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator());
                    }else{
                      if(snapshot.hasData){
                        if(snapshot.data!.isEmpty){
                          db.createGame(game);
                          return const Text("Jogo cadastrado com sucesso");
                        }else{
                          return const Text("Jogo já cadastrado");
                        }
                      }
                    }
                    return const Text("Erro ao cadastrar jogo");
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Ok"),
                  ),
                ],
              ),
              barrierDismissible: false
            );
            
            nameController.clear();
            descriptionController.clear();
            releaseDateController.clear();

            Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),],
    );
  }
}