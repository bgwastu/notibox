import 'package:get/get.dart';

import 'package:notibox/app/modules/home/bindings/home_binding.dart';
import 'package:notibox/app/modules/home/views/home_view.dart';
import 'package:notibox/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:notibox/app/modules/onboarding/views/onboarding_view.dart';
import 'package:notibox/app/modules/settings/bindings/settings_binding.dart';
import 'package:notibox/app/modules/settings/views/settings_view.dart';
import 'package:notibox/app/modules/splash/bindings/splash_binding.dart';
import 'package:notibox/app/modules/splash/views/splash_view.dart';

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
  ];
}
