import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/data/notion_provider.dart';

class CreateInboxController extends GetxController {
  final _notionProvider = Get.put(NotionProvider());
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
        await _notionProvider.createInbox(
            inbox: Inbox(
          title: title,
          description: description,
          label: selectedLabel,
          reminder: reminder,
        ));
        EasyLoading.dismiss();
        Get.back(result: true);
      } on DioError catch (e) {
        print(';(');
        await EasyLoading.dismiss();
        EasyLoading.showError(e.toString());
      }
    }
  }
}
