import 'package:flutter/material.dart';
import 'package:streak_counters/pages/home.dart';
import 'package:streak_counters/services/objectbox_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final objectBox = await ObjectBoxHelper.create();
  runApp(CounterApp(objectBox: objectBox));
}

class CounterApp extends StatelessWidget {
  final ObjectBoxHelper objectBox;

  CounterApp({required this.objectBox});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterHomePage(objectBox: objectBox),
    );
  }
}
