import 'package:background_fetch/background_fetch.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/main.dart';
import 'package:notibox/services/notification_service.dart';

Future<void> initPlatformState() async {
  await BackgroundFetch.configure(
      BackgroundFetchConfig(
          minimumFetchInterval: 15,
          stopOnTerminate: false,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          startOnBoot: true,
          requiredNetworkType: NetworkType.ANY), (String taskId) async {
    notificationInit();
    final listInbox = await InboxService().getListInbox();
    await createReminder(listInbox);

    BackgroundFetch.finish(taskId);
  }, (String taskId) async {
    BackgroundFetch.finish(taskId);
  });
}

Future<void> backgroundFetchHeadlessTask(HeadlessTask task) async {
  final String taskId = task.taskId;
  final bool isTimeout = task.timeout;
  if (isTimeout) {
    BackgroundFetch.finish(taskId);
    return;
  }
  await hiveInit();
  notificationInit();
  final listInbox = await InboxService().getListInbox();
  await createReminder(listInbox);
  BackgroundFetch.finish(taskId);
}
