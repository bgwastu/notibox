import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:notibox/app/data/model/inbox_model.dart';

Future<void> createReminder(List<Inbox> listInbox) async {
  AwesomeNotifications().cancelAllSchedules();

  // Create notification for each inbox (if has reminder)
  listInbox.forEach((inbox) async {
    if (inbox.reminder != null && inbox.reminder!.isAfter(DateTime.now())) {
      await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: inbox.pageId!.hashCode,
            channelKey: 'reminder',
            title: inbox.title,
            body: inbox.description,
            autoCancel: true,
            createdLifeCycle: NotificationLifeCycle.Background,
          ),
          schedule: NotificationCalendar.fromDate(date: inbox.reminder!));
    }
  });
}

void notificationInit() {
  AwesomeNotifications().initialize('resource://drawable/res_app_icon', [
    NotificationChannel(
        channelKey: 'reminder',
        channelName: 'Reminder',
        channelDescription: 'Notification for reminder',
        enableLights: true,
        importance: NotificationImportance.Max,
        enableVibration: true,
        playSound: true,
        ledColor: Colors.white)
  ]);
}