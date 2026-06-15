import 'package:flutter/material.dart';
import 'package:todo_app/models/notification_service.dart';
import 'package:todo_app/view_models/app_view_model.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/views/bottom_sheet.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Plugin-Schnittstellen vorbereiten
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        Provider<NotificationService>.value(value: notificationService),
        ChangeNotifierProvider(create: (_) => AppViewModel()),
      ],
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
    {'id': 'example-1', 'title': 'Beispieltask 1', 'done': false},
    {'id': 'example-2', 'title': 'Beispieltask 2', 'done': false},
    {'id': 'example-3', 'title': 'Beispieltask 3', 'done': false},
  ];

  // Schlüssel, unter dem die Task-Liste in SharedPreferences gespeichert wird.
  static const String tasksStorageKey = 'tasks';

  @override
  void initState() {
    super.initState();

    // Bereits gespeicherte Tasks laden, sobald das Widget erstellt wird.
    loadTasks();
  }

  // Funktionen

  //generiert für jeden neuen Task eine eindeutge ID ahhand des Zeitpunkts
  String createTaskId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  // Speichert die aktuelle Task-Liste auf dem Gerät.
  Future<void> saveTasks() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance(); // öffnet lokalen Speicher.

    // SharedPreferences kann keine List<Map> direkt speichern.
    // Deshalb wird die Task-Liste in einen JSON-String umgewandelt.
    final String tasksAsJson = jsonEncode(tasks); // wandelt Liste als String um

    await preferences.setString(
      tasksStorageKey,
      tasksAsJson,
    ); // speichert den Sting
  }

  // Lädt zuvor gespeicherte Task-Liste vom Gerät.
  Future<void> loadTasks() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    final String? tasksAsJson = preferences.getString(tasksStorageKey);

    // Beim ersten App-Start gibt es noch keine gespeicherten Tasks.
    // In dem Fall bleiben die Beispiel-Tasks bestehen.
    if (tasksAsJson == null) {
      return;
    }
    // Den gespeicherten JSON-String wieder in Dart-Liste umwandeln.
    final List<dynamic> decodedTasks = jsonDecode(tasksAsJson);

    // Die einzelnen Listen-Elemente wieder in Task-Maps umwandeln.
    final List<Map<String, dynamic>> loadedTasks = decodedTasks.map((task) {
      return Map<String, dynamic>.from(task);
    }).toList();

    // Nach asynchronem Vorgang prüfen, ob das Widget noch existiert.
    if (!mounted) {
      return;
    }

    //Beispiel-Tasks durch die gespeicherten Tasks ersetzen.
    setState(() {
      tasks.clear();
      tasks.addAll(loadedTasks);
    });
  }

  void addTask(String title) {
    if (title.trim().isEmpty) return;

    setState(() {
      tasks.insert(0, {
        'id': createTaskId(),
        'title': title.trim(),
        'done': false,
      });
    });

    // Geänderten Zustand dauerhaft speichern
    saveTasks();
  }

  void deleteTask(int taskIndex) {
    setState(() {
      tasks.removeAt(taskIndex);
    });

    // Geänderten Zustand dauerhaft speichern
    saveTasks();
  }

  void editTask(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    setState(() {
      tasks[index]['title'] = newTitle.trim();
    });

    // Geänderten Zustand dauerhaft speichern
    saveTasks();
  }

  // Variables

  int? selectedID;

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

                        // speichert die neue Reihenfolge der Tasks.
                        saveTasks();
                      },

                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return Dismissible(
                          key: ValueKey(task['id']),
                          onDismissed: (direction) {
                            // aktualisiert die Oberfläche und speichert die Liste
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
                              color: viewModel.colorMedium,
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),

                              // Styles für die Checkboxes
                              child: ListTile(
                                selected: selectedID == task['id'],
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

                                      // Erledigt-Staus speichern.
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
