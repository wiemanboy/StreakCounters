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
      title: 'Streak Counters',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        cardColor: Colors.grey[850],
        primaryColor: Colors.purple[900],
        appBarTheme: AppBarTheme(
          color: Colors.purple[900],
        ),
        textTheme: TextTheme(
          headlineLarge: TextStyle(color: Colors.white),
          headlineSmall: TextStyle(color: Colors.white70),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: CounterHomePage(objectBox: objectBox),
    );
  }
}
