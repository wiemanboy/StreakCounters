import 'package:flutter/material.dart';

class DeleteForm extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;

  DeleteForm({
    required this.itemName,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Are you sure?', textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Deleting "$itemName" cannot be undone.'),
        ],
      ),
      actions: [
        Row (
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ],
    );
  }
}
