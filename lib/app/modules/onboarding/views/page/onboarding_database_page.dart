import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notibox/app/config/ui_helpers.dart';
import 'package:notibox/app/modules/onboarding/controllers/onboarding_controller.dart';

class OnboardingDatabasePage extends StatelessWidget {
  const OnboardingDatabasePage({ Key? key }) : super(key: key);

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
                    'Add your Notion token',
                    style: Theme.of(context).textTheme.headline6,
                    textAlign: TextAlign.center,
                  ),
                  IconButton(
                      onPressed: () {
                        //TODO: add help for Notion database
                      },
                      icon: Icon(Icons.help),
                      iconSize: 22,
                      tooltip: 'Get Help')
                ],
              ),
              Text(
                'This application needs your Notion integration API to be able to work properly.',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              verticalSpaceMedium,
              TextFormField(
                controller: controller.databaseController,
                decoration: InputDecoration(labelText: 'Notion API Token'),
                minLines: 1,
                maxLines: null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Notion API cannot be empty';
                  }
                },
              ),
              verticalSpaceSmall,
              Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                      onPressed: controller.databaseNext,
                      icon: Icon(Icons.chevron_right),
                      label: Text('Next'.toUpperCase())))
            ],
          ),
        ),
      ),
    );
  }
}