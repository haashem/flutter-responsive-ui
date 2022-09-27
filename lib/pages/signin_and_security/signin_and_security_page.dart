import 'package:appleid_dashboard/shared/page_scaffold.dart';
import 'package:appleid_dashboard/shared/responsive.dart';
import 'package:flutter/material.dart' hide Card;

import '../../../shared/components/card.dart';
import '../../../shared/components/modal.dart';
import 'view_model/signin_security_card_type.dart';
import 'widgets/account_security.dart';

class SignInAndSecurityPage extends StatefulWidget {
  const SignInAndSecurityPage({Key? key}) : super(key: key);

  @override
  State<SignInAndSecurityPage> createState() => _SignInAndSecurityPageState();
}

class _SignInAndSecurityPageState extends State<SignInAndSecurityPage> {
  void onCardPressed(SignInSecurityCardType type) {
    showDialog(
        context: context,
        barrierColor: Colors.grey.withOpacity(0.8),
        barrierDismissible: true,
        builder: (context) {
          switch (type) {
            case SignInSecurityCardType.appleId:
              break;
            case SignInSecurityCardType.password:
              break;
            case SignInSecurityCardType.accountSecurity:
              return Modal(
                icon: Icons.security,
                title: 'Account Security',
                child: AccountSecurity(
                  onDevicePressed: () {},
                ),
                onCloseButtonPressed: () => Navigator.of(context).pop(),
              );
          }
          return Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Sign-In and Security',
      subtitle:
          'Manage settings related to signing in to your account, account security, as well as how to recover your data when you’re having trouble signing in.',
      child: Center(
        child: Responsive(
          mobile: _BelowDesktopLayout(onCardPressed: onCardPressed),
          tablet: _BelowDesktopLayout(onCardPressed: onCardPressed),
          desktop: _DesktopLayout(onCardPressed: onCardPressed),
        ),
      ),
    );
  }
}

class _BelowDesktopLayout extends StatelessWidget {
  final ValueChanged<SignInSecurityCardType> onCardPressed;

  const _BelowDesktopLayout({Key? key, required this.onCardPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Card(
          title: 'Apple ID',
          subtitle: 'hashemp206@yahoo.com',
          icon: Icons.apple,
        ),
        const Card(
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
          onPressed: () =>
              onCardPressed(SignInSecurityCardType.accountSecurity),
        ),
        const Card(
          title: 'Notification Email',
          subtitle: 'hashem.rc@gmail.com',
          icon: Icons.notification_add_outlined,
        ),
        const Card(
          title: 'Account Recovery',
          subtitle: 'iCloud Data Recovery Service',
          icon: Icons.support_sharp,
        ),
        const Card(
          title: 'Legacy Contact',
          subtitle: 'Not Set Up',
          icon: Icons.group,
        ),
        const Card(
          title: 'Sign in with Apple',
          subtitle: '19 apps and websites',
          icon: Icons.approval_outlined,
        ),
        const Card(
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
  final ValueChanged<SignInSecurityCardType> onCardPressed;
  const _DesktopLayout({Key? key, required this.onCardPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Card(
              title: 'Apple ID',
              subtitle: 'hashemp206@yahoo.com',
              icon: Icons.apple,
            ),
            const Card(
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
              onPressed: () =>
                  onCardPressed(SignInSecurityCardType.accountSecurity),
            ),
            const Card(
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
