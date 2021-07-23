import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notibox/app/inbox/feedback/feedback_controller.dart';
import 'package:notibox/utils/ui_helpers.dart';

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = FeedbackController();

    return WillPopScope(
      onWillPop: () async {
        if (controller.isDraft()) {
          final res = await showModal(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Your feedback draft will be removed.'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'.toUpperCase())),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feedback'),
          actions: [_send(controller)],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
    );
  }

  Widget _send(FeedbackController controller) {
    return TextButton(
      onPressed: controller.send,
      child: Text(
        'Send'.toUpperCase(),
        style: Get.textTheme.button!.copyWith(color: Colors.white),
      ),
    );
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
