import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/app/inbox/update_inbox/update_inbox_dialog.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class ViewInboxController extends GetxController {
  final _notionProvider = Get.put(InboxService());

  Future<void> updateInbox(Inbox inbox) async {
    final res = await Get.dialog(UpdateInboxDialog(inbox));
    // if updated then return true (refresh)
    if (res != null) {
      Get.back(result: {'data': res, 'status': 'update'});
    }
  }

  Future<void> deleteInbox(Inbox inbox) async {
    try {
      EasyLoading.show();
      await _notionProvider.deleteInbox(pageId: inbox.pageId!);
      await EasyLoading.dismiss();
      Get.back();
      Get.back(result: {'data': true, 'status': 'delete'});
    } on DioError catch (e) {
      await EasyLoading.dismiss();
      await Sentry.captureException(e, stackTrace: e.stackTrace);
      EasyLoading.showError('An error has occurred');
    }
  }
}
