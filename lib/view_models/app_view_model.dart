// Ablageort für Funktionen und Farben

import 'package:flutter/material.dart';

// Notwendig für Task-Speicherung im Cache

class Task {
  String title;
  bool complete;

  Task(this.title, this.complete);
}

class AppViewModel extends ChangeNotifier {
  List<Task> tasks = <Task>[];

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
