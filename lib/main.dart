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
        appBar: AppBar(backgroundColor: Colors.amber.shade600,
        title: const Text('Addictive Tasks'),
        ),
        body: Column(
          children: [
            // header view
            Expanded(
              flex: 1,
              child: Container(color: Colors.amber.shade100),
            ),
            
            // task info view
            Expanded(
              flex: 1,
              child: Container(color: Colors.amber.shade200),
            ),

            // task list view
            Expanded(
              flex: 7,
              child: Container(color: Colors.amber.shade300),
            ),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print('printing pressed...');
          },
          backgroundColor: Colors.amber.shade600,
          child: Icon(Icons.add),
        ),
      ),

    );
  }
}