import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/feedback/feedback_controller.dart';
import 'package:notibox/utils/ui_helpers.dart';

class FeedbackDialog extends AlertDialog {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FeedbackController());

    return WillPopScope(
      onWillPop: () async {
        if (controller.isDraft()) {
          final res = await showModal(
            context: context,
             builder: (context) => 
              AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text('Your feedback draft will be removed.'),
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
              ));
          if (res != null) {
              return res as bool;
            }
            return false;
        }

        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AlertDialog(
          insetPadding: const EdgeInsets.all(8.0),
          title: const Text('Feedback'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _name(controller),
                    verticalSpaceSmall,
                    _email(controller),
                    verticalSpaceSmall,
                    _feedback(controller),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            _send(controller),
          ],
        ),
      ),
    );
  }

  Widget _send(FeedbackController controller) {
    return TextButton(
        onPressed: controller.send, child: Text('Send'.toUpperCase()));
  }

  TextFormField _email(FeedbackController controller) {
    return TextFormField(
      controller: controller.emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      minLines: 1,
      maxLines: null,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Email cannot be empty';
        }

        if (!text.isEmail) {
          return 'Invalid email';
        }
      },
    );
  }

  TextFormField _feedback(FeedbackController controller) {
    return TextFormField(
      controller: controller.feedbackController,
      decoration: const InputDecoration(
        labelText: 'Feedback',
      ),
      minLines: 3,
      maxLines: null,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Feedback cannot be empty';
        }
      },
    );
  }

  TextFormField _name(FeedbackController controller) {
    return TextFormField(
      controller: controller.nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
      ),
      minLines: 1,
      maxLines: null,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Name cannot be empty';
        }
      },
    );
  }
}
