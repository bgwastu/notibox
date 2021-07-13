import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/data/model/inbox_model.dart';
import 'package:notibox/app/modules/home/controllers/create_inbox_controller.dart';
import 'package:shimmer/shimmer.dart';

class CreateInboxDialog extends AlertDialog {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateInboxController());
    return WillPopScope(
      onWillPop: () async {
        await Get.dialog(AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Your current progress will be removed.'),
          actions: [
            TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel'.toUpperCase())),
            TextButton(
                onPressed: () {
                  Get.back();
                  Get.back(result: false);
                },
                child: Text('Discard'.toUpperCase())),
          ],
        ));
        return false;
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
                    TextFormField(
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
                    ),
                    verticalSpaceSmall,
                    TextFormField(
                      controller: controller.descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      minLines: 1,
                      maxLines: null,
                    ),
                    verticalSpaceSmall,
                    DateTimeField(
                      format: DateFormat("yyyy-MM-dd HH:mm"),
                      decoration: InputDecoration(
                          labelText: 'Reminder', prefixIcon: Icon(Icons.alarm)),
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                        if (date != null) {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(
                                currentValue ?? DateTime.now()),
                          );
                          return DateTimeField.combine(date, time);
                        } else {
                          return currentValue;
                        }
                      },
                      onChanged: (dateTime) => controller.reminder = dateTime,
                    ),
                    verticalSpaceSmall,
                    FutureBuilder<List<Select>>(
                        future: controller.getListLabel(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Wrap(
                              spacing: 4,
                              children: List<Widget>.generate(
                                  snapshot.data!.length, (int index) {
                                return Obx(() => FilterChip(
                                      label: Text(snapshot.data![index].name),
                                      backgroundColor: snapshot
                                          .data![index].color!
                                          .withOpacity(0.3),
                                      selected:
                                          controller.chipIndex.value == index,
                                      selectedColor:
                                          snapshot.data![index].color,
                                      shape: StadiumBorder(side: BorderSide()),
                                      onSelected: (bool selected) {
                                        if (selected) {
                                          controller.chipIndex.value = index;
                                          controller.selectedLabel =
                                              snapshot.data![index];
                                        }
                                      },
                                    ));
                              }).toList(),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer.fromColors(
                                child: Wrap(
                                  spacing: 4,
                                  children:
                                      List<Widget>.generate(5, (int index) {
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
                        }),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            Obx(() => TextButton(
                onPressed:
                    !controller.isReady.value ? null : controller.saveInbox,
                child: Text('Save Inbox'.toUpperCase()))),
          ],
        ),
      ),
    );
  }
}
