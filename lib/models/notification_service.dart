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
  }
}
