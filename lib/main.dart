import 'package:flutter/material.dart';
import 'package:todo_app/models/notification_service.dart';
import 'package:todo_app/view_models/app_view_model.dart';
import 'package:todo_app/models/task_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/views/bottom_sheet.dart';

// Plugin-Schnittstellen vorbereiten
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final taskStorageService = TaskStorageService();
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppViewModel(taskStorageService, notificationService),
        ),
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
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<AppViewModel>(context, listen: false);

    // Bereits gespeicherte Tasks laden, sobald das Widget erstellt wird.
    viewModel.loadTasks();
  }

  // Variables

  //UI-Auswahl
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
              toolbarHeight: 90,
              leadingWidth: 100,
              centerTitle: false,
              titleSpacing: 0,
              backgroundColor: viewModel.colorText,
              leading: Padding(
                padding: const EdgeInsets.all(3),
                child: Image.asset(
                  'assets/images/logo_freigestellt.png',
                  fit: BoxFit.contain,
                ),
              ),
              title: Text(
                'Task Drive',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'BungeeShade',
                  fontSize: 40,
                  fontWeight: FontWeight(600),
                  color: viewModel.colorLight,
                ),
              ),
            ),
            body: Column(
              children: [
                // header, wo z.B. User-Daten stehen könnten
                Expanded(
                  flex: 1,
                  child: Container(
                    color: viewModel.colorDarkest,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      'Hello User 🐱',
                      style: TextStyle(
                        fontFamily: 'BungeeInline',
                        fontSize: 28,
                        color: viewModel.colorText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Infos über die Tasks (z.B. wie viele übrig sind)
                // Könnte aber auch für die Kategorien-Unterseite sein
                Expanded(
                  flex: 1,
                  child: Container(
                    color: viewModel.colorDark,
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    child: Row(
                      children: [
                        // Übersicht: Gesamtzahl aller Tasks
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: viewModel.colorLight,
                              border: Border.all(
                                color: viewModel.colorText,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        '${viewModel.numTasks}',
                                        style: TextStyle(
                                          fontFamily: 'BungeeInline',
                                          fontSize: 28,
                                          color: viewModel.colorText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: FittedBox(
                                      child: Text(
                                        'Total Tasks',
                                        style: TextStyle(
                                          fontFamily: 'BungeeInline',
                                          color: viewModel.colorText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Übersicht: Anzahl der noch offenen Tasks
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: viewModel.colorLight,
                              border: Border.all(
                                color: viewModel.colorText,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: FittedBox(
                                      child: Text(
                                        '${viewModel.numTasksRemaining}',
                                        style: TextStyle(
                                          fontFamily: 'BungeeInline',
                                          fontSize: 28,
                                          color: viewModel.colorText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: FittedBox(
                                      child: Text(
                                        'Remaining Tasks',
                                        style: TextStyle(
                                          fontFamily: 'BungeeInline',
                                          color: viewModel.colorText,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Ansicht der Listen-Elemente
                Expanded(
                  flex: 7,
                  child: Container(
                    color: viewModel.colorMedium,
                    child: ReorderableListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: viewModel.tasks.length,

                      // überschreibt die Standard-Einstellung für weißen Hintergrund von Drag-Items
                      proxyDecorator: (child, index, animation) {
                        return Material(
                          color: Colors.transparent,
                          child: child,
                        );
                      },

                      onReorderItem: viewModel.reorderTask,

                      itemBuilder: (context, index) {
                        final task = viewModel.tasks[index];

                        debugPrint("Task: ${task['title']} ID: ${task['id']}");
                        debugPrint("Active: ${viewModel.activeTaskId}");

                        return Dismissible(
                          key: ValueKey(task['id']),
                          onDismissed: (direction) {
                            // aktualisiert die Oberfläche und speichert die Liste
                            viewModel.deleteTask(index);
                          },
                          background: Container(
                            margin: EdgeInsets.fromLTRB(5, 0, 5, 12),
                            decoration: BoxDecoration(
                              color: viewModel.colorAccent1,
                              borderRadius: BorderRadius.circular(16),
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
                                    viewModel.editTask(index, newValue);
                                  },
                                ),
                                context,
                              );
                            },

                            child: Card(
                              color: viewModel.activeTaskId == task['id']
                                  ? viewModel.colorDarkest.withValues(
                                      alpha: 0.3,
                                    )
                                  : viewModel.colorLight,
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 3,

                              // Styles für die Checkboxes
                              child: ListTile(
                                selected: selectedID == task['id'],
                                contentPadding: const EdgeInsets.only(
                                  left: 16,
                                  right: 0,
                                ),

                                title: Text(
                                  task['title'],
                                  style: TextStyle(
                                    fontFamily: 'Alatsi',
                                    fontSize: 20,
                                    fontWeight: FontWeight(400),
                                    color: viewModel.colorText,
                                    decoration: task['done']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Transform.scale(
                                      scale: 1.3,
                                      child: Checkbox(
                                        value: task['done'],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        side: BorderSide(
                                          color: viewModel.colorDarkest,
                                          width: 2,
                                        ),
                                        activeColor: viewModel.colorDarkest,
                                        checkColor: viewModel.colorLight,
                                        onChanged: (newValue) {
                                          viewModel.toggleTaskDone(
                                            index,
                                            newValue,
                                          );
                                        },
                                      ),
                                    ),

                                    // Startet für diesen Task einen zufälligen Timer
                                    SizedBox(
                                      width: 48,
                                      height: 56,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () async {
                                            await viewModel
                                                .startReminderForTask(task);
                                          },
                                          child: Center(
                                            child: Icon(
                                              Icons.timer_outlined,
                                              color: viewModel.colorDarkest,
                                              size: 28,
                                              weight: 400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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

            floatingActionButton: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  // wird später durch Abbruch-Button ersetzt
                  heroTag: "notification_test",
                  onPressed: () async {
                    await viewModel.scheduleTestNotification();
                  },
                  backgroundColor: viewModel.colorText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: viewModel.colorLight, width: 2),
                  ),
                  child: Icon(
                    Icons.timer_off_outlined,
                    color: viewModel.colorLight,
                  ),
                ),

                const SizedBox(height: 12),

                FloatingActionButton(
                  heroTag: "add_task",
                  onPressed: () {
                    viewModel.bottomSheetBuilder(
                      BottomSheetView(
                        initialText: "",
                        onSubmit: viewModel.addTask,
                      ),
                      context,
                    );
                  },
                  backgroundColor: viewModel.colorText,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: viewModel.colorLight, width: 2),
                  ),
                  child: Icon(Icons.add, color: viewModel.colorLight),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
