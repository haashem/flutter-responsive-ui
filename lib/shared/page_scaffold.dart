import 'package:flutter/material.dart' hide Card;

class PageScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  const PageScaffold(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(0.7)),
              ),
              const SizedBox(
                height: 40,
              ),
              child
            ],
          ),
        ),
      ),
    );
  }
}
