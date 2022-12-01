import 'package:flutter/material.dart';
import 'package:flutterexample/views/hello_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "stateful",
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        home: const HomePage());
  }
}
