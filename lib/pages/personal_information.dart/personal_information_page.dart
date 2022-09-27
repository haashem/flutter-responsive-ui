import 'package:flutter/material.dart' hide Card;

import '../../../shared/components/card.dart';
import '../../../shared/page_scaffold.dart';
import '../../shared/responsive.dart';

class PersonalInformationPage extends StatelessWidget {
  const PersonalInformationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Personal Information',
      subtitle:
          'Manage your personal information, including phone numbers and email addresses where you can be reached.',
      child: Center(
        child: Responsive(
          mobile: _BelowDesktopLayout(),
          tablet: _BelowDesktopLayout(),
          desktop: _DesktopLayout(),
        ),
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
            title: 'Name',
            subtitle: 'Hashem Abounajmi',
            icon: Icons.person_outline),
        Card(
          title: 'Country / Region',
          subtitle: 'United Arab Emirates',
          icon: Icons.public_outlined,
        ),
        Card(
          title: 'Reachable At',
          subtitle: '2 email addresses',
          icon: Icons.chat_bubble_outline,
        ),
        Card(
          title: 'Birthday',
          subtitle: 'July 15, 1990',
          icon: Icons.calendar_month,
        ),
        Card(
          title: 'Language',
          subtitle: 'English (US)',
          icon: Icons.language,
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
                title: 'Name',
                subtitle: 'Hashem Abounajmi',
                icon: Icons.person_outline),
            Card(
              title: 'Country / Region',
              subtitle: 'United Arab Emirates',
              icon: Icons.public_outlined,
            ),
            Card(
              title: 'Reachable At',
              subtitle: '2 email addresses',
              icon: Icons.chat_bubble_outline,
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
              title: 'Birthday',
              subtitle: 'July 15, 1990',
              icon: Icons.calendar_month,
            ),
            Card(
              title: 'Language',
              subtitle: 'English (US)',
              icon: Icons.language,
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
