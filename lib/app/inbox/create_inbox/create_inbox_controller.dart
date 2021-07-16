import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/utils/ui_helpers.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CreateInboxController extends GetxController {
  final _notionProvider = Get.put(InboxService());
  Rx<bool> isReady = false.obs;
  Select? selectedLabel;
  DateTime? reminder;

  late RxInt chipIndex = 0.obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<List<Select>> getListLabel() async {
    final listLabel = await _notionProvider.getListLabel();
    isReady.value = true;
    return listLabel;
  }

  bool isDraft() {
    return titleController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        selectedLabel != null ||
        reminder != null;
  }

  Future<void> saveInbox() async {
    hideInput();
    if (formKey.currentState!.validate()) {
      final title = titleController.text;
      final description = descriptionController.text;

      if (selectedLabel?.id == 'no-label') {
        selectedLabel = null;
      }

      try {
        EasyLoading.show();
        final inbox = Inbox(
          title: title,
          description: description,
          label: selectedLabel,
          reminder: reminder,
        );
        await _notionProvider.createInbox(inbox: inbox);
        EasyLoading.dismiss();
        Get.back(result: inbox);
      } on DioError catch (e) {
        await EasyLoading.dismiss();
        await Sentry.captureException(e, stackTrace: e.stackTrace);
        EasyLoading.showError('An error has occurred');
      }
    }
  }
}
