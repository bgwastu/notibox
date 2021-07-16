import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notibox/config/theme.dart';
import 'package:notibox/routes/app_pages.dart';
import 'package:notibox/services/background_service.dart';
import 'package:notibox/services/notification_service.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app/settings/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await hiveInit();
  notificationInit();
  await _firebaseInit();
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  await SentryFlutter.init(
    (options) {
      options.dsn = const String.fromEnvironment('SENTRY_DSN');
    },
    appRunner: () => runApp(
      GetMaterialApp(
        title: 'Notibox',
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        theme: lightTheme,
        builder: EasyLoading.init(),
        darkTheme: darkTheme,
        themeMode: SettingsRepository.isDarkMode() == null
            ? ThemeMode.system
            : SettingsRepository.isDarkMode()! as bool
                ? ThemeMode.dark
                : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        enableLog: true,
      ),
    ),
  );
  easyLoadingConfig();
}

Future<void> _firebaseInit() async {
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

Future<void> hiveInit() async {
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('settings');
}

void easyLoadingConfig() {
  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.black
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..animationDuration = const Duration(milliseconds: 100)
    ..indicatorWidget = const CircularProgressIndicator(
      color: Colors.white,
    );
}
