import 'package:flutter/material.dart';

class InfoAvatar extends StatelessWidget {
  const InfoAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 84,
          height: 84,
          decoration: BoxDecoration(
            image: const DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(
                  'assets/images/profile-imge.png',
                )),
            borderRadius: BorderRadius.circular(84),
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
          ),

          // child: Icon(
          //   Icons.account_circle_outlined,
          //   size: 48,
          //   color: Theme.of(context).colorScheme.background,
          // ),
        ),
        const SizedBox(height: 24),
        Text(
          'Hashem Abounajmi',
          style: Theme.of(context).textTheme.headline6?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'hashemp206@yahoo.com',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.7)),
        )
      ],
    );
  }
}
