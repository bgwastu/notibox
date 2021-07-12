import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/data/notion_provider.dart';

class HomeController extends GetxController {
  final _notionProvider = Get.put(NotionProvider());
  Rx<List<Inbox>> listInbox = Rx([]);
  Rx<bool> isError = false.obs;

  final indicator = GlobalKey<RefreshIndicatorState>();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    indicator.currentState!.show();
    getListInbox();
  }

  Future<void> getListInbox() async {
    try {
      listInbox.value = await _notionProvider.getListInbox();
    } catch (e) {
      isError.value = true;
    }
  }
}
