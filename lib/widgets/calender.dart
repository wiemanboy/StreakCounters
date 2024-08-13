import 'package:flutter/material.dart';

import '../models/count.dart';

class Calender extends StatelessWidget {
  final List<List<List<Count>>> streaks;

  Calender({
    required this.streaks,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Text(streaks.first.toString())],
    );
  }
}
