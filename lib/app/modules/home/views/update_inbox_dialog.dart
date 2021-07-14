import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/modules/home/controllers/update_inbox_controller.dart';
import 'package:shimmer/shimmer.dart';

class UpdateInboxDialog extends AlertDialog {
  final Inbox inbox;

  UpdateInboxDialog(this.inbox);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateInboxController());
    controller.currentInbox = inbox;

    return WillPopScope(
      onWillPop: () async {
        if (controller.isDraft()) {
          final res = await Get.dialog(
              AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Your current progress will be removed.'),
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
          return res;
        }

        return true;
      },
      child: Padding(
        padding: EdgeInsets.all(8),
        child: AlertDialog(
          insetPadding: EdgeInsets.all(8.0),
          title: Text('Create Inbox'),
          content: Container(
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
            _updateInbox(controller),
          ],
        ),
      ),
    );
  }

  Obx _updateInbox(UpdateInboxController controller) {
    return Obx(() => TextButton(
        onPressed: !controller.isReady.value ? null : controller.updateInbox,
        child: Text('Update Inbox'.toUpperCase())));
  }

  FutureBuilder<List<Select>> _label(UpdateInboxController controller) {
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
                      label: Text(label.name),
                      backgroundColor: label.color!.withOpacity(0.3),
                      selected: controller.chipIndex.value == index,
                      selectedColor: label.color,
                      shape: StadiumBorder(side: BorderSide()),
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
                child: Wrap(
                  spacing: 4,
                  children: List<Widget>.generate(5, (int index) {
                    return FilterChip(
                      label: Text('dummy'),
                      backgroundColor: Colors.white,
                      selected: false,
                      selectedColor: Colors.white,
                      onSelected: null,
                    );
                  }).toList(),
                ),
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade100);
          }
          return Container();
        });
  }

  DateTimeField _reminder(UpdateInboxController controller) {
    return DateTimeField(
      controller: controller.reminderController,
      format: DateFormat("yyyy-MM-dd HH:mm"),
      decoration:
          InputDecoration(labelText: 'Reminder', prefixIcon: Icon(Icons.alarm)),
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

  TextFormField _description(UpdateInboxController controller) {
    return TextFormField(
      controller: controller.descriptionController,
      decoration: InputDecoration(
        labelText: 'Description',
      ),
      minLines: 1,
      maxLines: null,
    );
  }

  TextFormField _title(UpdateInboxController controller) {
    return TextFormField(
      controller: controller.titleController,
      decoration: InputDecoration(
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
