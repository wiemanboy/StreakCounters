import 'package:flutter/material.dart';
import 'package:streak_counters/models/streak.dart';
import 'package:streak_counters/services/objectbox_helper.dart';

class CounterWidget extends StatefulWidget {
  final Streak streak;
  final ObjectBoxHelper objectBox;
  final VoidCallback onUpdate;

  CounterWidget({
    Key? key,
    required this.streak,
    required this.objectBox,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int streakValue;

  @override
  void initState() {
    super.initState();
    streakValue = widget.streak.getStreakLength();
  }

  void completeCounter() {
    setState(() {
      widget.streak.completeToday();
      widget.objectBox.updateStreak(widget.streak);
      streakValue = widget.streak.getStreakLength();
    });
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              Text(
                widget.streak.name,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ]),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    widget.objectBox.updateStreak(widget.streak);
                    setState(() {
                      streakValue = widget.streak.getStreakLength();
                    });
                    widget.onUpdate();
                  },
                  tooltip: 'See calendar',
                  icon: Icon(Icons.calendar_month),
                ),
                Spacer(),
                Text(
                  '$streakValue',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Spacer(),
                IconButton(
                  onPressed: completeCounter,
                  tooltip: 'Complete today',
                  icon: Icon(Icons.check),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
