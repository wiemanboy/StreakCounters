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
      widget.objectBox.updateCounter(widget.streak);
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
            Text(
              widget.streak.name,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              '$streakValue',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: completeCounter,
                  tooltip: 'Increment',
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
