import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SettingsController>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('API Integration Token'),
            subtitle: Text('Your Notion internal integration token'),
            onTap: () async {
              final res = await Get.dialog(
                  alertDialog('API Token', controller.getToken()));
              if (res != null) {
                controller.updateToken(res);
              }
            },
          ),
          ListTile(
            title: Text('Database ID'),
            subtitle: Text(
              SettingsRepository.getDatabaseId() ?? '',
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () async {
              final res = await Get.dialog(
                  alertDialog('Database ID', controller.getDatabaseId()));
              if (res != null) {
                controller.updateToken(res);
              }
            },
          ),
          Divider(),
          SwitchListTile(
              title: Text('Dark Mode'),
              value: Get.isDarkMode,
              onChanged: (val) => controller.toggleDarkMode(val))
        ],
      ),
    );
  }
}

Widget alertDialog(String title, String currentValue) {
  String result = '';
  final controller = TextEditingController(text: currentValue);
  final key = GlobalKey<FormState>();
  return Form(
    key: key,
    child: AlertDialog(
      title: Text('Edit $title'),
      content: TextFormField(
        decoration: InputDecoration(labelText: title),
        onChanged: (v) => result = v,
        controller: controller,
        maxLines: null,
        validator: (v) {
          if (v == null || v.isEmpty) {
            return '$title can not be empty';
          }
        },
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                Get.back(result: result);
              }
            },
            child: Text('Update'.toUpperCase()))
      ],
    ),
  );
}
