import 'package:appleid_dashboard/shared/page_scaffold.dart';
import 'package:flutter/material.dart' hide Card;

import '../../../shared/components/card.dart';

class SignInAndSecurityPage extends StatefulWidget {
  const SignInAndSecurityPage({Key? key}) : super(key: key);

  @override
  State<SignInAndSecurityPage> createState() => _SignInAndSecurityPageState();
}

class _SignInAndSecurityPageState extends State<SignInAndSecurityPage> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Sign-In and Security',
      subtitle:
          'Manage settings related to signing in to your account, account security, as well as how to recover your data when you’re having trouble signing in.',
      child: Center(
        child: _DesktopLayout(),
      ),
    );
  }
}

class _BelowDesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Card(
          title: 'Apple ID',
          subtitle: 'hashemp206@yahoo.com',
          icon: Icons.apple,
        ),
        Card(
          title: 'Password',
          subtitle: 'Last updated December 22, 2017',
          icon: Icons.password,
        ),
        Card(
          title: 'Account Security',
          subtitle: """
Two-factor authentication
2 trusted phone numbers
3 trusted devices""",
          icon: Icons.security,
        ),
        Card(
          title: 'Notification Email',
          subtitle: 'hashem.rc@gmail.com',
          icon: Icons.notification_add_outlined,
        ),
        Card(
          title: 'Account Recovery',
          subtitle: 'iCloud Data Recovery Service',
          icon: Icons.support_sharp,
        ),
        Card(
          title: 'Legacy Contact',
          subtitle: 'Not Set Up',
          icon: Icons.group,
        ),
        Card(
          title: 'Sign in with Apple',
          subtitle: '19 apps and websites',
          icon: Icons.approval_outlined,
        ),
        Card(
          title: 'App-Specific Password',
          subtitle: 'No passwords',
          icon: Icons.app_blocking,
        )
      ].fold(
        [],
        (previousValue, element) =>
            previousValue +
            [
              element,
              const SizedBox(
                height: 16,
              )
            ],
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: const [
            Card(
              title: 'Apple ID',
              subtitle: 'hashemp206@yahoo.com',
              icon: Icons.apple,
            ),
            Card(
              title: 'Password',
              subtitle: 'Last updated December 22, 2017',
              icon: Icons.password,
            ),
            Card(
              title: 'Account Security',
              subtitle: """
Two-factor authentication
2 trusted phone numbers
3 trusted devices""",
              icon: Icons.security,
            ),
            Card(
              title: 'Notification Email',
              subtitle: 'hashem.rc@gmail.com',
              icon: Icons.notification_add_outlined,
            ),
          ].fold(
            [],
            (previousValue, element) =>
                previousValue +
                [
                  element,
                  const SizedBox(
                    height: 16,
                  )
                ],
          ),
        ),
        Column(
          children: const [
            Card(
              title: 'Account Recovery',
              subtitle: 'iCloud Data Recovery Service',
              icon: Icons.support_sharp,
            ),
            Card(
              title: 'Legacy Contact',
              subtitle: 'Not Set Up',
              icon: Icons.group,
            ),
            Card(
              title: 'Sign in with Apple',
              subtitle: '19 apps and websites',
              icon: Icons.approval_outlined,
            ),
            Card(
              title: 'App-Specific Password',
              subtitle: 'No passwords',
              icon: Icons.app_blocking,
            )
          ].fold(
            [],
            (previousValue, element) =>
                previousValue +
                [
                  element,
                  const SizedBox(
                    height: 16,
                  )
                ],
          ),
        )
      ].fold(
        [],
        (previousValue, element) =>
            previousValue +
            [
              element,
              const SizedBox(
                width: 16,
              )
            ],
      ),
    );
  }
}
