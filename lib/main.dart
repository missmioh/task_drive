import 'package:flutter/material.dart';
import 'package:todo_app/view_models/app_view_model.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/views/bottom_sheet.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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

  static const String tasksStorageKey = 'tasks';

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // Funktionen

  Future<void> saveTasks() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance(); // öffnet lokalen Speicher

    final String tasksAsJson = jsonEncode(tasks); // wandelt Liste als String um

    await preferences.setString(
      tasksStorageKey,
      tasksAsJson,
    ); // speichert den Sting
  }

  Future<void> loadTasks() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final String? tasksAsJson = preferences.getString(tasksStorageKey);

    if (tasksAsJson == null) {
      return;
    }

    final List<dynamic> decodedTasks = jsonDecode(tasksAsJson);

    final List<Map<String, dynamic>> loadedTasks = decodedTasks.map((task) {
      return Map<String, dynamic>.from(task);
    }).toList();

    if (!mounted) {
      return;
    }

    setState(() {
      tasks.clear();
      tasks.addAll(loadedTasks);
    });
  }

  void addTask(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      tasks.insert(0, {'title': title.trim(), 'done': false});
    });

    saveTasks();
  }

  void deleteTask(int taskIndex) {
    setState(() {
      tasks.removeAt(taskIndex);
    });

    saveTasks();
  }

  void editTask(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    setState(() {
      tasks[index]['title'] = newTitle.trim();
    });

    saveTasks();
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

                      // überschreibt die Standard-Einstellung für weißen Hintergrund von Drag-Items
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          color: Colors.transparent,
                          child: child,
                        );
                      },

                      onReorderItem: (oldIndex, newIndex) {
                        setState(() {
                          // if (newIndex > oldIndex) newIndex -= 1;
                          final task = tasks.removeAt(oldIndex);
                          tasks.insert(newIndex, task);
                        });

                        saveTasks();
                      },

                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return Dismissible(
                          key: ValueKey(task['title']),
                          onDismissed: (direction) {
                            deleteTask(index);
                          },
                          background: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: viewModel.colorAccent1,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.delete,
                                color: viewModel.colorAccent2,
                              ),
                            ),
                          ),

                          // Registriert, wenn der Nutzer auf den Text klickt
                          child: GestureDetector(
                            onTap: () {
                              viewModel.bottomSheetBuilder(
                                BottomSheetView(
                                  initialText: task['title'],
                                  onSubmit: (newValue) {
                                    editTask(index, newValue);
                                  },
                                ),
                                context,
                              );
                            },

                            child: Card(
                              key: ValueKey(task['title']),
                              color: viewModel.colorMedium,
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),

                              // Styles für die Checkboxes
                              child: ListTile(
                                trailing: Transform.scale(
                                  scale: 1.3,
                                  child: Checkbox(
                                    value: task['done'],
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(4),
                                    ),
                                    side: BorderSide(
                                      color: viewModel.colorDark,
                                      width: 2,
                                    ),
                                    activeColor: viewModel.colorText,
                                    checkColor: viewModel.colorLight,
                                    onChanged: (newValue) {
                                      setState(() {
                                        task['done'] = newValue ?? false;
                                      });

                                      saveTasks();
                                    },
                                  ),
                                ),
                                title: Text(
                                  task['title'],
                                  style: TextStyle(
                                    decoration: task['done']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
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
                  BottomSheetView(initialText: "", onSubmit: addTask),
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
