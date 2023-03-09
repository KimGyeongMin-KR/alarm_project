
import 'package:alarm/home/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const KeepGoing()
  );
}

class KeepGoing extends StatelessWidget {
  const KeepGoing({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep Going',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoadingPage(),
    );
  }
}

