import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/counter.dart';

class CounterHomePage extends StatefulWidget {
  @override
  _CounterHomePageState createState() => _CounterHomePageState();
}

class _CounterHomePageState extends State<CounterHomePage> {
  List<String> counterKeys = [];

  @override
  void initState() {
    super.initState();
    loadCounterKeys();
  }

  Future<void> loadCounterKeys() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      counterKeys = preferences.getStringList('counterKeys') ?? [];
    });
  }

  Future<void> saveCounterKeys() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setStringList('counterKeys', counterKeys);
  }

  void addCounter() {
    setState(() {
      String newCounterKey = UniqueKey().toString();
      counterKeys.add(newCounterKey);
      saveCounterKeys();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
      ),
      body: ListView.builder(
        itemCount: counterKeys.length,
        itemBuilder: (context, index) {
          return Counter(key: Key(counterKeys[index]), counterKey: counterKeys[index]);
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
