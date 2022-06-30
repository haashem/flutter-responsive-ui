import 'package:flutter/material.dart';

class AccountSecurity extends StatelessWidget {
  final VoidCallback onDevicePressed;
  const AccountSecurity({super.key, required this.onDevicePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Two-factor authentication',
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 8,
        ),
        Text('2 trusted phone numbers',
            style:
                Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 17)),
        const SizedBox(
          height: 8,
        ),
        Text('3 trusted devices',
            style:
                Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 17)),
        const SizedBox(
          height: 16,
        ),
        Text(
          'When you sign in on a new device or web browser, a verification code will be sent to your Apple devices or your trusted phone numbers.',
          style: Theme.of(context).textTheme.bodyText2,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 24,
        ),
        TrustedDeviceList(
          onDevicePressed: onDevicePressed,
        ),
        const SizedBox(
          height: 48,
        ),
      ],
    );
  }
}

class TrustedDeviceList extends StatelessWidget {
  final VoidCallback onDevicePressed;
  const TrustedDeviceList({super.key, required this.onDevicePressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '3 trusted devices',
          style: Theme.of(context)
              .textTheme
              .headline5
              ?.copyWith(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 16,
        ),
        DeviceTile(
          name: 'Hashem’s iPhone',
          onPressed: onDevicePressed,
        ),
        const SizedBox(
          height: 8,
        ),
        DeviceTile(
          name: 'Hashem’s MacBook Pro',
          onPressed: onDevicePressed,
        )
      ],
    );
  }
}

class DeviceTile extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  const DeviceTile({
    super.key,
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
