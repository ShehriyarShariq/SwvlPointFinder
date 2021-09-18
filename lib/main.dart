import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Swvl Point Finder',
        theme: ThemeData(
          primaryColor: Color.fromRGBO(251, 21, 59, 1),
        ),
        home: new Container());
  }
}
