import 'package:flutter/material.dart';
import 'package:todo_app/view_models/app_view_model.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/views/bottom_sheet.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppViewModel(),
      child: const AddictiveTasks(),
    ),
  );
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

  // Funktionen

  void addTask(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      tasks.add({'title': title.trim(), 'done': false});
    });
  }

  void deleteTask(int taskIndex) {
    setState(() {
      tasks.removeAt(taskIndex);
    });
  }

  // Oberfläche

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Schriftzug rechte Ecke deaktiviert
      home: Consumer<AppViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: viewModel.colorDarkest,
              title: const Text('Addictive Tasks'),
            ),
            body: Column(
              children: [
                // header, wo z.B. User-Daten stehen könnten
                Expanded(
                  flex: 1,
                  child: Container(color: viewModel.colorLight),
                ),

                // Infos über die Tasks (z.B. wie viele übrig sind)
                // Könnte aber auch für die Kategorien-Unterseite sein
                Expanded(
                  flex: 1,
                  child: Container(color: viewModel.colorMedium),
                ),

                // Ansicht der Listen-Elemente
                Expanded(
                  flex: 7,
                  child: Container(
                    color: viewModel.colorDark,
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

                        return Dismissible(
                          key: ValueKey(task['title']),
                          onDismissed: (direction) {
                            setState(() {
                              deleteTask(index);
                            });
                          },
                          child: Card(
                            key: ValueKey(task['title']),
                            color: viewModel.colorMedium,
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),

                            child: CheckboxListTile(
                              value: task['done'],
                              side: BorderSide(
                                color: viewModel.colorDark,
                                width: 2,
                              ),
                              activeColor: viewModel.colorText,
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
                viewModel.bottomSheetBuilder(
                  BottomSheetView(addTask: addTask),
                  context,
                );
              },
              backgroundColor: viewModel.colorDarkest,
              child: Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
