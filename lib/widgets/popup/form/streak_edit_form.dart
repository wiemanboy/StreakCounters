import 'package:flutter/material.dart';
import 'package:streak_counters/models/streak.dart';

class StreakEditForm extends StatelessWidget {
  final Streak streak;
  final void Function(String) onSave;

  StreakEditForm({
    required this.streak,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController(text: streak.name);

    return AlertDialog(
      title: Text('Edit Streak'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            String newName = nameController.text;
            onSave(newName);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
