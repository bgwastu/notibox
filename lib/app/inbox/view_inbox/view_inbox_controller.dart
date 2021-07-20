import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/app/inbox/update_inbox/update_inbox_page.dart';

class ViewInboxController extends GetxController {
  final _notionProvider = Get.put(InboxService());

  void updateInbox(Inbox inbox) {
    Get.back();
    Get.to(() => UpdateInboxPage(inbox: inbox));
  }

  Future<void> deleteInbox(Inbox inbox) async {
    try {
      EasyLoading.show();
      await _notionProvider.deleteInbox(pageId: inbox.pageId!);
      await EasyLoading.dismiss();
      Get.back();
      Get.back(result: {'data': true, 'status': 'delete'});
    } on HomeException catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showError(e.message);
    }
  }
}
