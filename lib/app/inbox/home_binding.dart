import 'package:get/get.dart';
import 'package:notibox/app/inbox/home_inbox/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
