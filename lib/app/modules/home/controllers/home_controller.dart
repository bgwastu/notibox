import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/data/notion_provider.dart';
import 'package:notibox/app/modules/home/exceptions/home_exception.dart';

class HomeController extends GetxController {
  final _notionProvider = Get.put(NotionProvider());
  Rx<List<Inbox>> listInbox = Rx([]);
  Rx<String> errorMessage = ''.obs;
  Rx<bool> init = true.obs;

  final indicator = GlobalKey<RefreshIndicatorState>();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    indicator.currentState!.show();
    await getListInbox();
    init.value = false;
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
      errorMessage.value = '';
    } on DioError catch (e) {
      errorMessage.value = HomeException.fromDioError(e).message;
    }
  }
}
