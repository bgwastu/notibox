import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/app/inbox/view_inbox/view_inbox_page.dart';
import 'package:notibox/services/notification_service.dart';

enum HomeState { Initial, NoInternet, Error, Empty, Loaded }

class HomeController extends GetxController {
  final _notionService = Get.put(InboxService());
  Rx<HomeState> homeState = HomeState.Initial.obs;

  Rx<List<Inbox>> listInbox = Rx([]);
  Rx<String> errorMessage = ''.obs;
  late StreamSubscription<InternetConnectionStatus> internetCheck;
  final indicator = GlobalKey<RefreshIndicatorState>();

  int selectedIndex = 0;
  late Inbox selectedInbox;

  @override
  void onInit() {
    super.onInit();
    homeState.value = HomeState.Initial;
    internetCheck = InternetConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          getListInbox();
          break;
        case InternetConnectionStatus.disconnected:
          homeState.value = HomeState.NoInternet;
          break;
      }
    });

    listInbox.listen((list) {
      if (list.isEmpty) {
        homeState.value = HomeState.Empty;
      }
    });
  }

  bool isReady() {
    return homeState.value != HomeState.Initial &&
        homeState.value != HomeState.Error &&
        homeState.value != HomeState.NoInternet;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    indicator.currentState!.show();
    await getListInbox();
  }

  @override
  void onClose() {
    super.onClose();
    internetCheck.cancel();
  }

  Future<void> createInbox(Inbox inbox) async {
    // Append the new inbox
    listInbox.value = [inbox, ...listInbox.value];
  }

  void updateInbox({required Inbox inbox, required int index}) {
    final pageId = listInbox.value[index].pageId;
    _notionService.updateInbox(inbox: inbox, pageId: pageId!);

    listInbox.value.replaceRange(index, index + 1, [inbox]);
    Get.forceAppUpdate();
  }

  void deleteInbox({required int index}) {
    listInbox.value.removeAt(index);
    Get.forceAppUpdate();
  }

  Future<void> viewInbox(Inbox inbox, int index) async {
    selectedIndex = index;
    selectedInbox = inbox;
    final res = await Navigator.of(Get.context!)
        .push(MaterialPageRoute(builder: (context) => ViewInboxPage(inbox)));
    if (res == 'delete') {
      deleteInbox(index: index);
    }
    if (res != null) {
      updateInbox(inbox: res as Inbox, index: index);
    }
  }

  Future<void> getListInbox() async {
    try {
      // Function only works when internet was available
      final hasConnection = await InternetConnectionChecker().hasConnection;
      if (hasConnection) {
        listInbox.value = await _notionService.getListInbox();

        // Add reminder
        await createReminder(listInbox.value);

        // State
        if (listInbox.value.isEmpty) {
          homeState.value = HomeState.Empty;
        } else {
          homeState.value = HomeState.Loaded;
        }
      } else {
        homeState.value = HomeState.NoInternet;
      }
    } on HomeException catch (e) {
      homeState.value = HomeState.Error;
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
