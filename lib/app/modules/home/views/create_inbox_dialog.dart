import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/modules/home/controllers/create_inbox_controller.dart';
import 'package:notibox/utils.dart';
import 'package:shimmer/shimmer.dart';

class CreateInboxDialog extends AlertDialog {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateInboxController());
    return WillPopScope(
      onWillPop: () async {
        if (controller.isDraft()) {
          final res = await Get.dialog(
              AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Your current progress will be removed.'),
                actions: [
                  TextButton(
                      onPressed: () => Get.back(result: false),
                      child: Text('Cancel'.toUpperCase())),
                  TextButton(
                      onPressed: () {
                        Get.back(result: true);
                      },
                      child: Text('Discard'.toUpperCase())),
                ],
              ),
              barrierDismissible: false);
          return res as bool;
        }

        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AlertDialog(
          insetPadding: const EdgeInsets.all(8.0),
          title: const Text('Create Inbox'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _title(controller),
                    verticalSpaceSmall,
                    _description(controller),
                    verticalSpaceSmall,
                    _reminder(controller),
                    verticalSpaceSmall,
                    _label(controller),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            _saveButton(controller),
          ],
        ),
      ),
    );
  }

  Obx _saveButton(CreateInboxController controller) {
    return Obx(() => TextButton(
        onPressed: !controller.isReady.value ? null : controller.saveInbox,
        child: Text('Save Inbox'.toUpperCase())));
  }

  FutureBuilder<List<Select>> _label(CreateInboxController controller) {
    return FutureBuilder<List<Select>>(
        future: controller.getListLabel(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
              spacing: 4,
              children:
                  List<Widget>.generate(snapshot.data!.length, (int index) {
                final label = snapshot.data![index];
                return Obx(() => FilterChip(
                      label: Text(
                        label.name,
                        style: Get.isDarkMode
                            ? Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(color: Colors.black)
                            : null,
                      ),
                      backgroundColor: Get.isDarkMode
                          ? label.color!
                          : label.color!.withOpacity(0.3),
                      selected: controller.chipIndex.value == index,
                      checkmarkColor: Get.isDarkMode ? Colors.black : null,
                      selectedColor:
                          Get.isDarkMode ? darken(label.color!) : label.color,
                      shape: const StadiumBorder(side: BorderSide()),
                      onSelected: (bool selected) {
                        if (selected) {
                          controller.chipIndex.value = index;
                          controller.selectedLabel = label;
                        }
                      },
                    ));
              }).toList(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
                baseColor: Get.isDarkMode
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
                highlightColor: Get.isDarkMode
                    ? Colors.grey.shade500
                    : Colors.grey.shade400,
                child: Wrap(
                  spacing: 4,
                  children: List<Widget>.generate(5, (int index) {
                    return const FilterChip(
                      label: Text('dummy'),
                      backgroundColor: Colors.white,
                      selectedColor: Colors.white,
                      onSelected: null,
                    );
                  }).toList(),
                ));
          }
          return Container();
        });
  }

  DateTimeField _reminder(CreateInboxController controller) {
    return DateTimeField(
      format: DateFormat.yMMMd().add_jm(),
      decoration:
          const InputDecoration(labelText: 'Reminder', prefixIcon: Icon(Icons.alarm)),
      onShowPicker: (context, currentValue) async {
        final date = await showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            initialDate: currentValue ?? DateTime.now(),
            lastDate: DateTime(2100));
        if (date != null) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          return DateTimeField.combine(date, time);
        } else {
          return currentValue;
        }
      },
      onChanged: (dateTime) => controller.reminder = dateTime,
    );
  }

  TextFormField _description(CreateInboxController controller) {
    return TextFormField(
      controller: controller.descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
      ),
      minLines: 1,
      maxLines: null,
    );
  }

  TextFormField _title(CreateInboxController controller) {
    return TextFormField(
      controller: controller.titleController,
      decoration: const InputDecoration(
        labelText: 'Title',
      ),
      minLines: 1,
      maxLines: null,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Title cannot be empty';
        }
      },
    );
  }
}
