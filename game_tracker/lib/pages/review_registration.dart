import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../jsonmodels/review_model.dart';
import '../services/sqlite.dart';

class ReviewRegistration extends StatefulWidget {
  
  int userId, gameId;
  String gameName;
  ReviewRegistration(this.gameId, this.userId, this.gameName, {super.key});


  @override
  State<ReviewRegistration> createState() => _ReviewRegistrationState();
}

class _ReviewRegistrationState extends State<ReviewRegistration> {

  DatabaseHelper db = DatabaseHelper();

  TextEditingController reviewController = TextEditingController();
  int? scoreController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
              widget.gameName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold
              ),
            ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Adicionar Review",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
              )
            )
          ),
          Divider(),
          Text("Nota"),
          DropdownButton(
            alignment: Alignment.centerLeft,
            value: scoreController,
            items:const [
              DropdownMenuItem(value: 1, child: Text("1")),
              DropdownMenuItem(value: 2, child: Text("2")),
              DropdownMenuItem(value: 3, child: Text("3")),
              DropdownMenuItem(value: 4, child: Text("4")),
              DropdownMenuItem(value: 5, child: Text("5")),
              DropdownMenuItem(value: 6, child: Text("6")),
              DropdownMenuItem(value: 7, child: Text("7")),
              DropdownMenuItem(value: 8, child: Text("8")),
              DropdownMenuItem(value: 9, child: Text("9")),
              DropdownMenuItem(value: 10, child: Text("10")),
            ],
            onChanged: (int? value) {
              setState(() {
                scoreController = value;
              });
            },
          ),
          TextField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: "Review"),
            controller: reviewController,
          ),

        ],
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

            if(scoreController == null) {
              return;
            }

            ReviewModel review = ReviewModel(
              userId: widget.userId,
              gameId: widget.gameId,
              score: scoreController!.toDouble(),
              description: reviewController.text,
              date: DateTime.now(),
            );

            if(review.description.isEmpty){
              return;
            }

            
          reviewController.clear();
          scoreController = null;

            Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),],
    );
  }
}