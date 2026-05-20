import 'package:flutter/material.dart';

void main() {

  runApp( AddictiveTasks() );
}

class AddictiveTasks extends StatelessWidget {
  const AddictiveTasks ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.green.shade100,
        title: const Text('Addictive Tasks'),
        ),
      ),
    );
  }
}