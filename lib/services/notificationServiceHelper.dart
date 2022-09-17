import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../model/tasks.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializeNotifaction() async {
    _configuredLocalTime();
    const AndroidInitializationSettings androidinitializeSettings =
        AndroidInitializationSettings("appicon");
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidinitializeSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotifcation);
  }

  selectNotifcation(String? payload) {
    if (payload != null) {
      print("Notifcation payload: $payload");
    } else {
      print("Notification Done");
    }
    Get.to(() => Container(
          color: Colors.white,
        ));
  }

  scheduledNotification(int hour, int minute, Task task) async {
    print("schedule notification called");
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'xyz',
        'fuck mother fucker',
        convertTime(hour, minute),
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('channelId', 'channelName')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configuredLocalTime() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  displayNotification(
      {required String notification_title,
      required String notification_body}) async {
    print("test notification");
    var androidPatformSpecificNotification = const AndroidNotificationDetails(
        'channelId', 'channelName',
        importance: Importance.max, priority: Priority.high);
    var platformSpecificNotification =
        NotificationDetails(android: androidPatformSpecificNotification);
    await flutterLocalNotificationsPlugin.show(
        0, notification_title, notification_body, platformSpecificNotification,
        payload: 'DefaultSound');
  }
}
