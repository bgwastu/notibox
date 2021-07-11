import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notibox/config/theme.dart';
import 'package:notibox/onboarding/onboarding_token_page.dart';

final _indexProvider = StateProvider((ref) => 0);

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int totalIndex = 3;
    final controller = PageController();
    return Scaffold(
      body: IndexedStack(
        children: [
          OnboardingTokenPage(),
          Center(child: Text('2')),
          Center(child: Text('3')),
        ],
      ),
    );
  }
}
