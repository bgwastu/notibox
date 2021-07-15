import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notibox/app/config/theme.dart';
import 'package:notibox/app/data/repository/settings_repository.dart';
import 'app/routes/app_pages.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hiveInit();
  await Firebase.initializeApp();
  notificationInit();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(
    GetMaterialApp(
      title: "Notibox",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppThemes.lightTheme,
      builder: EasyLoading.init(),
      darkTheme: AppThemes.darkTheme,
      themeMode: SettingsRepository.isDarkMode() == null ? ThemeMode.system : SettingsRepository.isDarkMode()! ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      enableLog: true,
    ),
  );
  easyLoadingConfig();
}

void notificationInit() {
  AwesomeNotifications().initialize('resource://drawable/res_app_icon', [
    NotificationChannel(
        channelKey: 'reminder',
        channelName: 'Reminder',
        channelDescription: 'Notification for reminder',
        enableLights: true,
        importance: NotificationImportance.Max,
        enableVibration: true,
        playSound: true,
        ledColor: Colors.white)
  ]);
}

Future<void> hiveInit() async {
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('settings');
}

void easyLoadingConfig() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.black
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..animationDuration = Duration(milliseconds: 100)
    ..indicatorWidget = CircularProgressIndicator(
      color: Colors.white,
    );
}
