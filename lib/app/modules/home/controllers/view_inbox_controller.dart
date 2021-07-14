import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/data/notion_provider.dart';

class ViewInboxController extends GetxController {
  final _notionProvider = Get.put(NotionProvider());

  Future<void> deleteInbox(Inbox inbox) async {
    Get.back();
    EasyLoading.show();
    await _notionProvider.deleteInbox(pageId: inbox.pageId!);
    EasyLoading.dismiss();
    Get.back(result: true);

  }
}