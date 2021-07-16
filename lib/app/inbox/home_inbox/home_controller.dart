import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notibox/app/inbox/create_inbox/create_inbox_dialog.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/app/inbox/view_inbox/view_inbox_dialog.dart';
import 'package:notibox/config/constants.dart';
import 'package:notibox/services/notification_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  final _notionProvider = Get.put(InboxService());
  Rx<List<Inbox>> listInbox = Rx([]);
  Rx<String> errorMessage = ''.obs;
  Rx<bool> init = true.obs;
  Rx<bool> isOffline = false.obs;
  late StreamSubscription<InternetConnectionStatus> internetCheck;
  final indicator = GlobalKey<RefreshIndicatorState>();

  @override
  void onInit() {
    super.onInit();
    internetCheck = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          isOffline.value = false;
          manualRefresh();
          break;
        case InternetConnectionStatus.disconnected:
          isOffline.value = true;
          break;
      }
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    indicator.currentState!.show();
    await getListInbox();
    init.value = false;
  }

  @override
  void onClose() {
    super.onClose();
    internetCheck.cancel();
  }

  Future<void> createInbox() async {
    final res = await Get.dialog(CreateInboxDialog());

    // Append the new inbox
    if (res != null) {
      listInbox.value = [res as Inbox, ...listInbox.value];
      manualRefresh();
    }
  }

  Future<void> viewInbox(Inbox inbox, int index) async {
    final res = await Get.dialog(ViewInboxDialog(inbox));

    // Update current inbox only
    if (res != null) {
      // Status check
      if (res['status'] == 'update') {
        final pageId = listInbox.value[index].pageId;
        (res['data'] as Inbox).pageId = pageId;
        listInbox.value.replaceRange(index, index + 1, [res['data'] as Inbox]);
        Get.forceAppUpdate();
      } else if (res['status'] == 'delete') {
        listInbox.value.removeAt(index);
        Get.forceAppUpdate();
      }
    }
  }

  Future<void> manualRefresh() async {
    indicator.currentState!.show();
    await getListInbox();
  }

  bool isError() {
    return errorMessage.value != '';
  }

  bool isEmpty() {
    return listInbox.value.isEmpty;
  }

  Future<void> getListInbox() async {
    try {
      listInbox.value = await _notionProvider.getListInbox();
      // Add reminder
      await createReminder(listInbox.value);
      errorMessage.value = '';
    } on DioError catch (e) {
      await Sentry.captureException(e, stackTrace: e.stackTrace);
      errorMessage.value = HomeException.fromDioError(e).message;
    }
  }

  Future<void> feedbackButton() async {
    EasyLoading.show();
    try {
      await launch(githubIssueUrl);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
