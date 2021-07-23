import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/app/inbox/update_inbox/update_inbox_view.dart';

class ViewInboxController extends GetxController {
  final _notionProvider = Get.put(InboxService());

  Future<void> updateInbox(Inbox inbox) async {
    final res = await Navigator.push(Get.context!, MaterialPageRoute(builder: (context) => UpdateInboxView(inbox)));
    if(res != null){
      Navigator.pop(Get.context!, res);
    }
  }

  Future<void> deleteInbox(Inbox inbox) async {
    try {
      EasyLoading.show();
      await _notionProvider.deleteInbox(pageId: inbox.pageId!);
      await EasyLoading.dismiss();
      Navigator.pop(Get.context!);
      Navigator.pop(Get.context!, 'delete');
    } on HomeException catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showError(e.message);
    }
  }
}
