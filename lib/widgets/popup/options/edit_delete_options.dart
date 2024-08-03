import 'package:flutter/material.dart';

class EditDeleteOptions extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  EditDeleteOptions({
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Edit'),
          onTap: () {
            Navigator.pop(context);
            onEdit();
          },
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Delete'),
          onTap: () {
            Navigator.pop(context);
            onDelete();
          },
        ),
      ],
    );
  }
}
