import 'package:flutter/material.dart';

import '../../../models/streak.dart';
import '../../calender.dart';

class CalenderInfo extends StatelessWidget {
  final Streak streak;

  CalenderInfo({
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Text(streak.name),
          Calender(streaks: streak.getGroupedStreaks()),
          Text('Longest streak: ${streak.getLongestStreak()}'),
        ],
      ),
    );
  }
}
