import 'package:flutter/material.dart';
import 'package:streak_counters/models/counter.dart';
import 'package:streak_counters/services/objectbox_helper.dart';

class CounterWidget extends StatefulWidget {
  final Counter counter;
  final ObjectBoxHelper objectBox;
  final VoidCallback onUpdate;

  CounterWidget({
    Key? key,
    required this.counter,
    required this.objectBox,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  late int counterValue;

  @override
  void initState() {
    super.initState();
    counterValue = widget.counter.value;
  }

  void incrementCounter() {
    setState(() {
      counterValue++;
      widget.counter.value = counterValue;
      widget.objectBox.updateCounter(widget.counter);
    });
    widget.onUpdate();
  }

  void decrementCounter() {
    setState(() {
      counterValue--;
      widget.counter.value = counterValue;
      widget.objectBox.updateCounter(widget.counter);
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
              widget.counter.key,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(
              '$counterValue',
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
