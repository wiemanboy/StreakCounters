import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter extends StatefulWidget {
  final String counterKey;

  Counter({Key? key, required this.counterKey}) : super(key: key);

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    loadCounter();
  }

  Future<void> loadCounter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      counter = preferences.getInt(widget.counterKey) ?? 0;
    });
  }

  Future<void> saveCounter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(widget.counterKey, counter);
  }

  void incrementCounter() {
    setState(() {
      counter++;
      saveCounter();
    });
  }

  void decrementCounter() {
    setState(() {
      counter--;
      saveCounter();
    });
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
              'Counter ${widget.counterKey}',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: decrementCounter,
                  tooltip: 'Decrement',
                  icon: Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: incrementCounter,
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
