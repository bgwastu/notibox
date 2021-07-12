import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/modules/onboarding/controllers/onboarding_controller.dart';

class OnboardingDatabasePage extends StatelessWidget {
  const OnboardingDatabasePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();
    return Form(
      key: controller.databaseFormKey,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 2 / 1,
                child: SvgPicture.asset('assets/images/smartphone_data.svg'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Clone the database',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                    onPressed: () {
                      //TODO: add help for Notion database
                    },
                    icon: Icon(Icons.help),
                    iconSize: 22,
                    tooltip: 'Get Help',
                  )
                ],
              ),
              Text(
                'This application uses custom database, duplicate it to your workspace and invite Notibox integration that you have created earlier.',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              verticalSpaceMedium,
              OutlinedButton.icon(
                  onPressed: controller.duplicateDatabase,
                  icon: Icon(Icons.copy),
                  label: Text('Duplicate Notibox Database'.toUpperCase())),
              verticalSpaceSmall,
              Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                      onPressed: controller.databaseNext,
                      icon: Icon(Icons.check_circle_outline),
                      label: Text('Finish'.toUpperCase())))
            ],
          ),
        ),
      ),
    );
  }
}
