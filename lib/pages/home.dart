import 'package:flutter/material.dart';
import 'package:streak_counters/models/counter.dart';
import 'package:streak_counters/services/objectbox_helper.dart';

import '../widgets/counter.dart';

class CounterHomePage extends StatefulWidget {
  final ObjectBoxHelper objectBox;

  CounterHomePage({required this.objectBox});

  @override
  _CounterHomePageState createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<CounterHomePage> {
  List<Counter> counters = [];

  @override
  void initState() {
    super.initState();
    loadCounters();
  }

  void loadCounters() {
    setState(() {
      counters = widget.objectBox.getAllCounters();
    });
  }

  void addCounter() {
    final newCounter = Counter(key: UniqueKey().toString());
    widget.objectBox.addCounter(newCounter);
    loadCounters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
      ),
      body: ListView.builder(
        itemCount: counters.length,
        itemBuilder: (context, index) {
          return CounterWidget(
            counter: counters[index],
            objectBox: widget.objectBox,
            onUpdate: loadCounters,
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
