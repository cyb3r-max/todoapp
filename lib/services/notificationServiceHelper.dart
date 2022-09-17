import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/screens/noteDetails.dart';

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
    Get.to(() => NoteDetails(label: payload));
  }

  scheduledNotification(int hour, int minute, Task task) async {
    print("schedule notification called");
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        task.title,
        task.note,
        convertTime(hour, minute),
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'your channel id',
          'your channel name',
        )),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|" + "${task.note}|");
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
    var androidPatformSpecificNotification = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var platformSpecificNotification =
        NotificationDetails(android: androidPatformSpecificNotification);
    await flutterLocalNotificationsPlugin.show(
        0, notification_title, notification_body, platformSpecificNotification,
        payload: 'DefaultSound');
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    //showDialog(context: context, builder: builder)
    Get.dialog(const Text('Welcome to flutter'));
  }
}
