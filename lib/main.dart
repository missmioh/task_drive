import 'package:flutter/material.dart';

void main() {
  runApp(AddictiveTasks());
}

class AddictiveTasks extends StatefulWidget {
  const AddictiveTasks({super.key});

  @override
  State<AddictiveTasks> createState() => _AddictiveTasksState();
}

class _AddictiveTasksState extends State<AddictiveTasks> {
  final List<Map<String, dynamic>> tasks = [
    {'title': 'Beispieltask 1', 'done': false},
    {'title': 'Beispieltask 2', 'done': false},
    {'title': 'Beispieltask 3', 'done': false},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Schriftzug rechte Ecke deaktiviert
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber.shade600,
          title: const Text('Addictive Tasks'),
        ),
        body: Column(
          children: [
            // header, wo z.B. User-Daten stehen könnten
            Expanded(flex: 1, child: Container(color: Colors.amber.shade100)),

            // Infos über die Tasks (z.B. wie viele übrig sind)
            // Könnte aber auch für die Kategorien-Unterseite sein
            Expanded(flex: 1, child: Container(color: Colors.amber.shade200)),

            // Ansicht der Listen-Elemente
            Expanded(
              flex: 7,
              child: Container(
                color: Colors.amber.shade300,
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: tasks.length,
                  onReorder: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) newIndex -= 1;
                      final task = tasks.removeAt(oldIndex);
                      tasks.insert(newIndex, task);
                    });
                  },
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return Card(
                      key: ValueKey(task['title']),
                      color: Colors.amber.shade200,
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: CheckboxListTile(
                        value: task['done'],
                        side: BorderSide(
                          color: Colors.amber.shade600,
                          width: 2,
                        ),
                        activeColor: Colors.blue,
                        title: Text(
                          task['title'],
                          style: TextStyle(
                            fontSize: 20,
                            decoration: task['done']
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            task['done'] = newValue;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
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
