import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// liefert Zeitzonen
import 'package:timezone/data/latest.dart' as tz;
// liefert Klassen und Funktionen um mit den Zeitzonen zu arbeiten
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

//notification service

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

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required int minutes,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifications',
      channelDescription: 'Geplante Erinnerungen',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    final scheduledTime = tz.TZDateTime.now(
      tz.local,
    ).add(Duration(minutes: minutes));

    await notifications.zonedSchedule(
      id: id,
      title: '⏰ Erinnerung',
      body: title,
      scheduledDate: scheduledTime,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> showTestNotification() async {
    debugPrint("showTestNotification wurde aufgerufen");
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

      debugPrint("notifications.show() wurde erfolgreich aufgerufen");
    } catch (e) {
      debugPrint("Fehler beim Anzeigen der Notification: $e");
    }
  }

  Future<void> scheduleTestNotification() async {
    await scheduleReminder(id: 1, title: 'Test Notification', minutes: 1);
    debugPrint('Test Benachrichtigung wurde ausgelöst');
  }
}
