import 'package:get/get.dart';
import 'package:notibox/app/inbox/create_inbox/create_inbox_controller.dart';

class CreateInboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateInboxController>(
      () => CreateInboxController(),
    );
  }
}
