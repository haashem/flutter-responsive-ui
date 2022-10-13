import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onPressed;
  const SideMenuItem(
      {Key? key,
      required this.title,
      this.selected = false,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6?.copyWith(
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onBackground),
      ),
    );
  }
}
