import 'dart:async';

import 'package:chaka_app/controllers/auth_controller.dart';
import 'package:chaka_app/providers/notification_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // singleton pattern
  static final NotificationService _notificationService =
      NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = "1";

  final authC = Get.put(AuthController());

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    channelId,
    "chakamobile",
    channelDescription:
        "This channel is responsible for all the local notifications",
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  static final IOSNotificationDetails _iosNotificationDetails =
      IOSNotificationDetails();

  final NotificationDetails notificationDetails = NotificationDetails(
    android: _androidNotificationDetails,
    iOS: _iosNotificationDetails,
  );

  Future<void> init() async {
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      defaultPresentAlert: false,
      defaultPresentBadge: false,
      defaultPresentSound: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    // tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  // Future<void> showNotification(
  //     int id, String title, String message, String payload) async {
  //   await flutterLocalNotificationsPlugin
  //       .show(id, title, message, notificationDetails, payload: payload);
  // }

  void showPeriodicNotification() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      if (authC.isLogged.value) {
        NotificationProvider().getAllNotifications().then((value) async {
          if (value.status.isOk) {
            if (value.body['isSuccess']) {
              List data = value.body['data'];

              if (data.isNotEmpty) {
                data.map((e) async {
                  await flutterLocalNotificationsPlugin.show(
                      e['id'], e['title'], e['message'], notificationDetails,
                      payload: e['id'].toString());
                });
              }
            }
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> onSelectNotification(String? payload) async {
    // handle notif tapped here...

    if (payload != null) {
      debugPrint('notification payload: $payload');
      NotificationProvider().updateNotification(1).then((value) {
        print(value);
      });
    }
    // await Get.toNamed(RouteName.presensi);
  }
}
