import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/inbox/home_inbox/home_exception.dart';
import 'package:notibox/app/inbox/inbox_model.dart';
import 'package:notibox/app/inbox/inbox_service.dart';
import 'package:notibox/utils/ui_helpers.dart';

class UpdateInboxController extends GetxController {
  final _notionService = Get.put(InboxService());
  Rx<bool> isReady = false.obs;
  Select? selectedLabel;
  DateTime? reminder;
  RxInt chipIndex = 0.obs;
  final Inbox currentInbox;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final reminderController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  UpdateInboxController(this.currentInbox) {
    titleController.text = currentInbox.title;
    descriptionController.text = currentInbox.description ?? '';

    if (currentInbox.reminder != null) {
      reminderController.text =
          DateFormat.yMMMd().add_jm().format(currentInbox.reminder!);
      reminder = currentInbox.reminder;
    }
  }

  Future<List<Select>> getListLabel() async {
    final listLabel = await _notionService.getListLabel();
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
    late bool isLabelDraft;

    // Check label draft
    if (isReady.value) {
      isLabelDraft = selectedLabel != currentInbox.label;
    } else {
      isLabelDraft = false;
    }

    return titleController.text != currentInbox.title ||
        descriptionController.text != currentInbox.description ||
        isLabelDraft ||
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
        final inbox = Inbox(
          pageId: currentInbox.pageId,
          title: title,
          description: description,
          label: selectedLabel,
          reminder: reminder,
        );
        EasyLoading.dismiss();
        Navigator.pop(Get.context!, inbox);
      } on HomeException catch (e) {
        await EasyLoading.dismiss();
        EasyLoading.showError(e.message);
      }
    }
  }
}
