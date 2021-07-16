import 'package:background_fetch/background_fetch.dart';
import 'package:notibox/app/data/notion_provider.dart';
import 'package:notibox/app/services/notification_service.dart';
import 'package:notibox/main.dart';

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
          requiredNetworkType: NetworkType.ANY), (String taskId) async {
    await hiveInit();
    notificationInit();
    final listInbox = await NotionProvider().getListInbox();
    await createReminder(listInbox);

    BackgroundFetch.finish(taskId);
  }, (String taskId) async {
    BackgroundFetch.finish(taskId);
  });
}

void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    BackgroundFetch.finish(taskId);
    return;
  }
  await hiveInit();
  notificationInit();
  final listInbox = await NotionProvider().getListInbox();
  await createReminder(listInbox);
  BackgroundFetch.finish(taskId);
}
