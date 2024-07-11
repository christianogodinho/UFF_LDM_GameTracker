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
  double nota = 0.0;

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
              value: nota,
              max: 10.0,
              label: "$nota",
              divisions: 20,
              onChanged: (novaNota) {
                setState(() {
                  nota = novaNota;
                }
              );
            }),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text("Review")),
            TextField(
              keyboardType: TextInputType.text,
              controller: reviewController,
            ),

          ],
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

            ReviewModel review = ReviewModel(
              userId: widget.userId,
              gameId: widget.gameId,
              score: nota,
              description: reviewController.text,
              date: DateTime.now(),
            );

            if(review.description.isEmpty){
              return;
            }

            
          reviewController.clear();
          nota = 0.0;

            Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),],
    );
  }
}