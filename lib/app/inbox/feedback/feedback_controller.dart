import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:notibox/utils/ui_helpers.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class FeedbackController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final feedbackController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isDraft() {
    return nameController.text.isNotEmpty ||
        emailController.text.isNotEmpty ||
        feedbackController.text.isNotEmpty;
  }

  Future<void> send() async {
    hideInput();
    if (formKey.currentState!.validate()) {
      final name = nameController.text;
      final email = emailController.text;
      final feedback = feedbackController.text;

      try {
        final id = await Sentry.captureMessage('Feedback');
        Sentry.captureUserFeedback(SentryUserFeedback(
            name: name,
            email: email,
            comments: feedback,
            eventId: id));
        await EasyLoading.dismiss();
        await EasyLoading.showSuccess('Your feedback has been sent');
        Navigator.pop(Get.context!);
      } catch (_) {
        await EasyLoading.dismiss();
      }
    }
  }
}
