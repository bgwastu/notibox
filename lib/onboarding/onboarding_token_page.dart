import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notibox/onboarding/onboarding_service.dart';
import 'package:notibox/config/ui_helpers.dart';
import 'package:notibox/onboarding/onboarding_database_page.dart';

class OnboardingTokenPage extends ConsumerWidget {
  const OnboardingTokenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final inputController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AspectRatio(
                aspectRatio: 2 / 1,
                child: SvgPicture.asset('assets/images/phone_maintenance.svg'),
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
                      onPressed: () {},
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
                controller: inputController,
                decoration: InputDecoration(labelText: 'Notion API Token'),
                minLines: 1,
                maxLines: null,
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Notion API cannot be empty';
                  }
                },
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton.icon(
                      onPressed: () async {
                        hideInput();
                        if (formKey.currentState!.validate()) {
                          EasyLoading.show();
                          final isCorrect = await authService
                              .checkToken(inputController.text);
                          if (!isCorrect) {
                            await EasyLoading.dismiss();
                            EasyLoading.showError('Token is not valid');
                            return;
                          }
                          EasyLoading.dismiss();
                          Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => OnboardingDatabasePage()),);
                        }
                      },
                      icon: Icon(Icons.chevron_right),
                      label: Text('Next'.toUpperCase())))
            ],
          ),
        ),
      ),
    );
  }
}
