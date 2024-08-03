import 'package:flutter/material.dart';
import 'package:streak_counters/models/streak.dart';
import 'package:streak_counters/services/objectbox_helper.dart';

import '../widgets/streak_counter.dart';

class CounterHomePage extends StatefulWidget {
  final ObjectBoxHelper objectBox;

  CounterHomePage({required this.objectBox});

  @override
  _CounterHomePageState createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<CounterHomePage> {
  List<Streak> streaks = [];

  @override
  void initState() {
    super.initState();
    loadStreakCounters();
  }

  void loadStreakCounters() {
    setState(() {
      streaks = widget.objectBox.getAllStreaks();
    });
  }

  void addCounter() {
    final newCounter = Streak(name: "New Counter");
    widget.objectBox.addStreak(newCounter);
    loadStreakCounters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Streak Counters', style: Theme.of(context).textTheme.headlineLarge),
      ),
      body: ListView.builder(
        itemCount: streaks.length,
        itemBuilder: (context, index) {
          return StreakCounter(
            streak: streaks[index],
            objectBox: widget.objectBox,
            onUpdate: loadStreakCounters,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addCounter,
        tooltip: 'Add Counter',
        child: Icon(Icons.add),
      ),
    );
  }
}
