import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/data/notion_provider.dart';

class UpdateInboxController extends GetxController {
  final _notionProvider = Get.put(NotionProvider());
  Rx<bool> isReady = false.obs;
  Select? selectedLabel;
  DateTime? reminder;
  late Inbox currentInbox;

  RxInt chipIndex = 0.obs;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final reminderController = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    titleController.text = currentInbox.title;
    descriptionController.text = currentInbox.description ?? '';

    if (currentInbox.reminder != null) {
      reminderController.text =
          DateFormat("yyyy-MM-dd HH:mm").format(currentInbox.reminder!);
      reminder = currentInbox.reminder;
    }
  }

  final formKey = GlobalKey<FormState>();

  Future<List<Select>> getListLabel() async {
    final listLabel = await _notionProvider.getListLabel();
    final listName = listLabel.map((e) => e.name).toList();

    // add into current form
    if (currentInbox.label != null) {
      selectedLabel = currentInbox.label;
      chipIndex.value = listName.indexOf(currentInbox.label!.name);
    }
    isReady.value = true;
    return listLabel;
  }

  bool isDraft() {
    return titleController.text != currentInbox.title ||
        descriptionController.text != currentInbox.description ||
        selectedLabel != currentInbox.label ||
        reminder != currentInbox.reminder;
  }

  Future<void> updateInbox() async {
    hideInput();
    if (formKey.currentState!.validate()) {
      final title = titleController.text;
      final description = descriptionController.text;

      if (selectedLabel?.id == 'no-label') {
        selectedLabel = null;
      }

      try {
        EasyLoading.show();
        await _notionProvider.updateInbox(
            inbox: Inbox(
              title: title,
              description: description,
              label: selectedLabel,
              reminder: reminder,
            ),
            pageId: currentInbox.pageId!);
        EasyLoading.dismiss();
        Get.back(result: true);
      } on DioError catch (e) {
        await EasyLoading.dismiss();
        EasyLoading.showError(e.toString());
      }
    }
  }
}
