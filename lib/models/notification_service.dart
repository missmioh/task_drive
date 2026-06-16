import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
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
}
