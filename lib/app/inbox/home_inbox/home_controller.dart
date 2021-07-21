import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/app/inbox/view_inbox/view_inbox_dialog.dart';
import 'package:notibox/routes/app_pages.dart';
import 'package:notibox/services/notification_service.dart';

class HomeController extends GetxController {
  final _notionProvider = Get.put(InboxService());
  Rx<List<Inbox>> listInbox = Rx([]);
  Rx<String> errorMessage = ''.obs;
  Rx<bool> init = true.obs;
  Rx<bool> isOffline = false.obs;
  late StreamSubscription<InternetConnectionStatus> internetCheck;
  final indicator = GlobalKey<RefreshIndicatorState>();

  Rx<int> selectedIndex = 0.obs;
  late Rx<Inbox> selectedInbox;

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
    final res = await Get.toNamed(Routes.createInbox);

    // Append the new inbox
    if (res != null) {
      listInbox.value = [res as Inbox, ...listInbox.value];
      getListInbox();
    }
  }

  void updateInbox(Inbox inbox) {
    final index = selectedIndex.value;
    final pageId = listInbox.value[index].pageId;
    inbox.pageId = pageId;
    listInbox.value.replaceRange(index, index + 1, [inbox]);
    Get.forceAppUpdate();
  }

  void deleteInbox() {
    listInbox.value.removeAt(selectedIndex.value);
    Get.forceAppUpdate();
  }

  Future<void> viewInbox(Inbox inbox, int index) async {
    selectedIndex.value = index;
    selectedInbox = inbox.obs;
    Get.dialog(ViewInboxDialog(inbox));
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
    } on HomeException catch (e) {
      errorMessage.value = e.message;
    }
  }

  Future<void> feedbackButton() async {
    // EasyLoading.show();
    // try {
    //   await launch('mailto:atticdeveloper@gmail.com');
    // } finally {
    //   EasyLoading.dismiss();
    //   EasyLoading.showError("You don't have email client");
    // }
  }
}
