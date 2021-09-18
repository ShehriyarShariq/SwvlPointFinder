import 'package:flutter/material.dart';

import 'features/WorkflowPicker/presentation/pages/workflow_picker.dart';

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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(251, 21, 59, 1),
      ),
      home: const WorkflowPicker(),
    );
  }
}
