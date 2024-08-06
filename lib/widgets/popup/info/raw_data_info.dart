import 'package:flutter/material.dart';

class RawDataInfo extends StatelessWidget {
  final String data;

  RawDataInfo({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(data),
    );
  }
}
