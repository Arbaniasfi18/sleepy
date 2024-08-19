import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {

    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/logo");

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();

  }

  static void onDidReceiveNotification(NotificationResponse response) {}

  static Future<void> instantNotification(String title, String body) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails("channel_id_7", "channel_name",
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
      )
    );

    await flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

}