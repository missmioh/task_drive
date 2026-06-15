import 'dart:math';

class ReminderItem {
  final int id;
  final String title;

  const ReminderItem({required this.id, required this.title});
}

//random duration generator

final random = Random();

Duration randomDuration() {
  // 5 bis 35 Minuten
  final minutes = random.nextInt(31) + 5;

  return Duration(minutes: minutes);
}

final scheduledTime = DateTime.now().add(randomDuration());

//notification service

class ReminderService {
  Future<void> scheduleReminder(ReminderItem item) async {
    final when = DateTime.now().add(randomDuration());

    // Hier später Notification planen

    print("Reminder für ${item.title} um $when");
  }
}


//local storage (shared preferences)