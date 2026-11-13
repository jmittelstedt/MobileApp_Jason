import 'package:flutter/material.dart';

import 'widgets/greeting_card.dart';

void main() {
  runApp(const FlutterTestsApp());
}

class FlutterTestsApp extends StatelessWidget {
  const FlutterTestsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Tests',
      home: Scaffold(
        appBar: AppBar(title: const Text('Greeting Card')),
        body: const Center(child: GreetingCard(userName: 'Alice')),
      ),
    );
  }
}
