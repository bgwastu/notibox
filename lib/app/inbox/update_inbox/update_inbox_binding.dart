import 'package:get/get.dart';
import 'package:notibox/app/inbox/update_inbox/update_inbox_controller.dart';

class UpdateInboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateInboxController>(
      () => UpdateInboxController(),
    );
  }
}
