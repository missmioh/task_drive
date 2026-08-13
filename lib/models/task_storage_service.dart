import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TaskStorageService {
  // Name des Speicherschlüssels
  static const String tasksStorageKey = 'tasks';

  // Speichert die aktuelle Task-Liste auf dem Gerät.
  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
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
  Future<List<Map<String, dynamic>>?> loadTasks() async {
    final SharedPreferences preferences =
        await SharedPreferences.getInstance();

    final String? tasksAsJson =
        preferences.getString(tasksStorageKey);

    // Beim ersten App-Start gibt es noch keine gespeicherten Tasks.
    // In dem Fall bleiben die Beispiel-Tasks bestehen.
    if (tasksAsJson == null) {
      return null;
    }

    // Den gespeicherten JSON-String wieder in Dart-Liste umwandeln.
    final List<dynamic> decodedTasks = jsonDecode(tasksAsJson);

    // Die einzelnen Listen-Elemente wieder in Task-Maps umwandeln.
    final List<Map<String, dynamic>> loadedTasks =
        decodedTasks.map((task) {
      return Map<String, dynamic>.from(task);
    }).toList();

    // gibt geladene Tasks zurück
    return loadedTasks;
  }
}