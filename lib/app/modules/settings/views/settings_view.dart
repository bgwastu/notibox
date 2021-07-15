import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
              onChanged: (val) => controller.toggleDarkMode(val)),
          Divider(),
          ListTile(
            title: Text('About'),
            onTap: () async {
              PackageInfo packageInfo = await PackageInfo.fromPlatform();
              showAboutDialog(
                  context: context,
                  applicationVersion: packageInfo.version,
                  children: [
                    Text(
                        'Notibox is an inbox application to store quick notes efficiently in Notion.')
                  ],
                  applicationIcon: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(8),
                      child: SvgPicture.asset(Get.isDarkMode
                          ? 'assets/logo/logo_dark.svg'
                          : 'assets/logo/logo_light.svg')));
            },
          ),
          ListTile(
            title: Text('Privacy Policy'),
            onTap: controller.showPrivacyPolicy,
          ),
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
