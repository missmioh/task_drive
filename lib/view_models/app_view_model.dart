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

  // Zufallsminuten-Generator

  int createRandomReminderMinutes() {
    final random = Random();
    return random.nextInt(41) + 5;
  }

  Future<void> startReminderForTask(
    Map<String, dynamic> task,
    NotificationService notificationService,
  ) async {
    final minutes = createRandomReminderMinutes();

    debugPrint("Reminder für '${task['title']}' in $minutes Minuten");

    await notificationService.scheduleReminder(
      id: task['id'] ?? task['title'].hashCode,
      title: task['title'],
      minutes: minutes,
    );
  }

  // Farb-Schemata

  Color colorLight = Colors.amber.shade100;
  Color colorMedium = Colors.amber.shade200;
  Color colorDark = Colors.amber.shade300;
  Color colorDarkest = Colors.amber.shade600;
  Color get colorText => const Color.fromARGB(255, 163, 116, 6);
  Color get colorAccent1 => const Color.fromARGB(179, 192, 9, 6);
  Color get colorAccent2 => const Color.fromARGB(255, 141, 41, 5);

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
