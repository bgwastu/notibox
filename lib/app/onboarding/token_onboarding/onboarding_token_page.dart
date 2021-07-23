import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notibox/app/onboarding/onboarding_controller.dart';
import 'package:notibox/utils/ui_helpers.dart';

class OnboardingTokenPage extends StatelessWidget {
  const OnboardingTokenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    return Form(
      key: controller.tokenFormKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 2 / 1,
                    child:
                        SvgPicture.asset('assets/images/phone_maintenance.svg'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add your Notion token',
                        style: Theme.of(context).textTheme.headline6,
                        textAlign: TextAlign.center,
                      ),
                      IconButton(
                          onPressed: controller.helpToken,
                          icon: const Icon(Icons.help),
                          iconSize: 22,
                          tooltip: 'Get Help'),
                    ],
                  ),
                  Text(
                    'This application needs your Notion integration API to be able to work properly.',
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.center,
                  ),
                  verticalSpaceMedium,
                  TextFormField(
                    controller: controller.tokenController,
                    decoration:
                        const InputDecoration(labelText: 'Notion API Token'),
                    minLines: 1,
                    maxLines: null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Notion API cannot be empty';
                      }
                    },
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                    onPressed: controller.tokenNext,
                    child: Text('Next'.toUpperCase())))
          ],
        ),
      ),
    );
  }
}
