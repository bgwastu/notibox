import 'package:get/get.dart';
import 'package:notibox/app/inbox/create_inbox/create_inbox_binding.dart';
import 'package:notibox/app/inbox/create_inbox/create_inbox_view.dart';
import 'package:notibox/app/inbox/home_binding.dart';
import 'package:notibox/app/inbox/home_inbox/home_view.dart';
import 'package:notibox/app/inbox/update_inbox/update_inbox_binding.dart';
import 'package:notibox/app/inbox/update_inbox/update_inbox_view.dart';
import 'package:notibox/app/onboarding/onboarding_binding.dart';
import 'package:notibox/app/onboarding/onboarding_view.dart';
import 'package:notibox/app/settings/settings_binding.dart';
import 'package:notibox/app/settings/settings_view.dart';
import 'package:notibox/app/splash/splash_binding.dart';
import 'package:notibox/app/splash/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.onboarding,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.splash,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.settings,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.createInbox,
      page: () => CreateInboxView(),
      binding: CreateInboxBinding(),
    ),
    GetPage(
      name: _Paths.updateInbox,
      page: () => UpdateInboxView(),
      binding: UpdateInboxBinding(),
    ),
  ];
}
