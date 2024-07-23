
import 'package:flutter/material.dart';
import 'package:game_tracker/models/review_model.dart';
import 'package:game_tracker/utils/sqlite.dart';

//Cria o diálogo de registro de review
class ReviewRegistrationDialog extends StatefulWidget {
  
  int userId, gameId;
  String gameName;
  Function updateAncestor;

  ReviewRegistrationDialog(this.gameId, this.userId, this.gameName, this.updateAncestor, {super.key});


  @override
  State<ReviewRegistrationDialog> createState() => _ReviewRegistrationState();
}

class _ReviewRegistrationState extends State<ReviewRegistrationDialog> {

  DatabaseHelper db = DatabaseHelper();

  TextEditingController reviewController = TextEditingController();
  double score = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Text(
            widget.gameName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text(
              "Adicionar Review",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              )
            )
          ),
          Divider(),
      ]
    ),
    content: Padding(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nota"),
          Slider(
            value: score,
            max: 10.0,
            label: "$score",
            divisions: 20,
            onChanged: (newScore) {
              setState(() {
                score = newScore;
              }
            );
          }),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text("Review")
          ),
          TextField(
            keyboardType: TextInputType.text,
            controller: reviewController,
          )],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            reviewController.clear();
            Navigator.of(context).pop();
          },
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () async{

            //Cria o objeto ReviewModel, insere no banco de dados e atualiza a tela do Widget ancestral
            ReviewModel review = ReviewModel(
              userId: widget.userId,
              gameId: widget.gameId,
              score: score,
              description: reviewController.text,
              date: DateTime.now(),
            );

            if(review.description.isEmpty){
              return;
            }

            await db.insertReview(review);

            reviewController.clear();
            score = 0.0;
            widget.updateAncestor();
            Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}