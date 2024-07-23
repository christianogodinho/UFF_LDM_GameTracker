import 'package:game_tracker/utils/sqlite.dart';
import 'package:flutter/material.dart';

class GenreSelectionDialog extends StatefulWidget {
  List<bool?> gendersList;
  GenreSelectionDialog(this.gendersList, {super.key});
  

  @override
  State<GenreSelectionDialog> createState() => _GenreSelectionDialogState();
}

class _GenreSelectionDialogState extends State<GenreSelectionDialog> {
  @override
  Widget build(BuildContext context) {

    DatabaseHelper db = DatabaseHelper();

    return AlertDialog(
      title: const Text("Selecione os gêneros"),
      content: FutureBuilder(
        future: db.getAllGenres(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(snapshot.data![index].name),
                  value: widget.gendersList[index],
                  onChanged: (bool? newValue) {
                    setState(() {
                      widget.gendersList[index] = newValue;
                    });
                  },
                );
              },
            );
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Ok"),
        ),
      ],
    );
  }
}