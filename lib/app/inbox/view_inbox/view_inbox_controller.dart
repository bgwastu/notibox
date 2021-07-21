import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/home_inbox/home_controller.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/routes/app_pages.dart';

class ViewInboxController extends GetxController {
  final _notionProvider = Get.put(InboxService());
  final _homeController = Get.find<HomeController>();

  void updateInbox(Inbox inbox) {
    Get.back();
    Get.toNamed(Routes.updateInbox);
  }

  Future<void> deleteInbox(Inbox inbox) async {
    try {
      EasyLoading.show();
      await _notionProvider.deleteInbox(pageId: inbox.pageId!);
      _homeController.deleteInbox();
      await EasyLoading.dismiss();
      Get.back();
      Get.back();
    } on HomeException catch (e) {
      await EasyLoading.dismiss();
      EasyLoading.showError(e.message);
    }
  }
}
