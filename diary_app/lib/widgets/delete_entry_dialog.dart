import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary_app/model/Diary.dart';
import 'package:diary_app/screens/main_page.dart';
import 'package:flutter/material.dart';

class DeleteEntryDialog extends StatelessWidget {
  const DeleteEntryDialog({
    Key? key,
    required this.bookCollectionReference,
    required this.diary,
  }) : super(key: key);

  final CollectionReference<Object?> bookCollectionReference;
  final Diary diary;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Delete Story?',
        style: TextStyle(color: Colors.red),
      ),
      content: Text('Are you sure? \n This action cannot be reversed'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            bookCollectionReference.doc(diary.id).delete().then((value) {
              //return Navigator.of(context).pop();
              return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ));
            });
          },
          child: Text('Delete'),
        )
      ],
    );
  }
}
