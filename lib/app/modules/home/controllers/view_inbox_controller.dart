import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/data/notion_provider.dart';
import 'package:notibox/app/modules/home/views/update_inbox_dialog.dart';

class ViewInboxController extends GetxController {
  final _notionProvider = Get.put(NotionProvider());

  Future<void> updateInbox(Inbox inbox) async {
    final res = await Get.dialog(UpdateInboxDialog(inbox));
    // if updated then return true (refresh)
    if(res != null){
      Get.back(result: true);
    }
  }

  Future<void> deleteInbox(Inbox inbox) async {
    EasyLoading.show();
    await _notionProvider.deleteInbox(pageId: inbox.pageId!);
    EasyLoading.dismiss();
    Get.back();
    Get.back(result: true);

  }
}