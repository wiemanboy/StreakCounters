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
      content: SizedBox(
        width: 300,
        height: 350,
        child: Column(
          children: [
            Text(streak.name),
            Calender(counts: streak.counts, interval: streak.interval!),
            Text('Longest streak: ${streak.getLongestStreak()}'),
          ],
        ),
      ),
    );
  }
}
