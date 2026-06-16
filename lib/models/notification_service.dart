import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// liefert Zeitzonen
import 'package:timezone/data/latest.dart' as tz;
// liefert Klassen und Funktionen um mit den Zeitzonen zu arbeiten
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Zeitzonen laden
    tz.initializeTimeZones();
    // nutzt das Android-eigene Launcher-Icon für Benachrichtigungen. Kann durch eigenes ersetzt werden
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //Paket das android und ios unterstützt. Hier wurde nur Android gesetzt.
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(settings: initSettings);

    // nach Berechtigung für Push-Benachrichtigungen fragen
    final androidPlugin = notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
  }

  Future<void> showTestNotification() async {
    print("showTestNotification wurde aufgerufen");
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Zum Testen lokaler Benachrichtigungen',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    try {
      await notifications.show(
        id: 0,
        title: 'Hallo! 👋',
        body: 'Wenn du das siehst, funktioniert alles.',
        notificationDetails: details,
      );

      print("notifications.show() wurde erfolgreich aufgerufen");
    } catch (e) {
      print("Fehler beim Anzeigen der Notification: $e");
    }
  }

  Future<void> scheduleTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Zum Testen lokaler Benachrichtigungen',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    final scheduledTime = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 10));

    try {
      await notifications.zonedSchedule(
        id: 1,
        title: '⏰ Geplante Erinnerung',
        body: 'Diese Notification wurde vor 10 Sekunden geplant.',
        scheduledDate: scheduledTime,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
      debugPrint("Scheduling erfolgreich");
    } catch (e) {
      debugPrint("Scheduling FEHLER: $e");
    }
  }
}
