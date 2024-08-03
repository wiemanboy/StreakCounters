import 'package:flutter/material.dart';
import 'package:streak_counters/models/streak.dart';

import '../../../models/enums/streak_interval.dart';

class StreakEditForm extends StatefulWidget {
  final Streak streak;
  final void Function(String) onSave;

  StreakEditForm({
    required this.streak,
    required this.onSave,
  });

  @override
  _StreakEditFormState createState() => _StreakEditFormState();
}

class _StreakEditFormState extends State<StreakEditForm> {
  late TextEditingController nameController;
  late StreakInterval selectedInterval;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.streak.name);
    selectedInterval = widget.streak.interval!;
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Streak'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          DropdownButton<StreakInterval>(
            isExpanded: true,
            value: selectedInterval,
            onChanged: (StreakInterval? newValue) {
              setState(() {
                selectedInterval = newValue!;
              });
            },
            items: StreakInterval.values
                .map((StreakInterval interval) => DropdownMenuItem(
              value: interval,
              child: Text(interval.toString().split('.').last),
            ))
                .toList(),
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
            widget.streak.interval = selectedInterval;
            widget.onSave(newName);
            Navigator.of(context).pop();
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
