// Ablageort für Funktionen und Farben

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todo_app/models/notification_service.dart';

// Notwendig für Task-Speicherung im Cache
// wird zurzeit nicht genutzt

// class Task {
//   String title;
//   bool complete;

//   Task(this.title, this.complete);
// }

class AppViewModel extends ChangeNotifier {
  // List<Task> tasks = <Task>[];

  final List<Map<String, dynamic>> tasks = [
    {'id': 1, 'title': 'Tick', 'done': false},
    {'id': 2, 'title': 'Trick', 'done': false},
    {'id': 3, 'title': 'Track', 'done': false},
  ];

  int? activeTaskId;

  void setActiveTask(int id) {
    activeTaskId = id;
    notifyListeners();
  }

  // Gesamtzahl aller Tasks
  int get numTasks => tasks.length;

  // Anzahl aller Tasks, die noch nicht erledigt sind
  int get numTasksRemaining {
    return tasks.where((task) => task['done'] != true).length;
  }

  // Task-Management

  void addTask(String title) {
    if (title.trim().isEmpty) return;

    tasks.insert(0, {
      'id': DateTime.now().microsecondsSinceEpoch,
      'title': title.trim(),
      'done': false,
    });

    notifyListeners();
  }

  void deleteTask(int taskIndex) {
    tasks.removeAt(taskIndex);

    notifyListeners();
  }

  void editTask(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return;

    tasks[index]['title'] = newTitle.trim();

    notifyListeners();
  }

  void reorderTask(int oldIndex, int newIndex) {
    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);

    notifyListeners();
  }

  void toggleTaskDone(int index, bool? newValue) {
    tasks[index]['done'] = newValue ?? false;
    notifyListeners();
  }

  // Zufallsminuten-Generator

  int createRandomReminderMinutes() {
    final random = Random();
    return random.nextInt(41) + 5;
  }

  // Task-Reminder

  Future<void> startReminderForTask(
    Map<String, dynamic> task,
    NotificationService notificationService,
  ) async {
    debugPrint("Task: ${task['title']}");
    debugPrint("ID: ${task['id']}");
    final minutes = createRandomReminderMinutes();

    debugPrint("Reminder für '${task['title']}' in $minutes Minuten");

    final id = task['id'] ?? task['title'].hashCode;

    if (activeTaskId != null) {
      await notificationService.cancelReminder();
    }

    await notificationService.scheduleReminder(
      title: task['title'],
      minutes: minutes,
    );
    debugPrint("SET ACTIVE TASK ID: $id");
    activeTaskId = id;
    notifyListeners();
  }

  // Farb-Schemata

  Color colorLight = const Color.fromARGB(255, 244, 227, 183);
  Color colorMedium = const Color.fromARGB(255, 186, 214, 182);
  Color colorDark = const Color.fromARGB(255, 166, 209, 204);
  Color colorDarkest = const Color.fromARGB(255, 126, 160, 186);
  Color get colorText => const Color.fromARGB(255, 102, 107, 133);
  Color get colorAccent1 => const Color.fromARGB(168, 219, 164, 147);
  Color get colorAccent2 => const Color.fromARGB(255, 166, 108, 88);

  // Bottom-Sheet, der über die ganze App konstant verwendet wird

  void bottomSheetBuilder(Widget bottomSheetView, BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      isScrollControlled: true,
      builder: ((context) {
        return bottomSheetView;
      }),
    );
  }
}
