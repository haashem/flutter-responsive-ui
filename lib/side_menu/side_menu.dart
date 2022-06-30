import 'package:appleid_dashboard/side_menu/info_avatar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'side_menu_item.dart';

class SideMenu extends StatefulWidget {
  final ValueChanged<int> onPressed;
  const SideMenu({Key? key, required this.onPressed}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final sections = const [
    'Sign-In and Security',
    'Personal Information',
    'Payment Methods',
    'Family Sharing',
    'Devices',
    'Privacy'
  ];

  final sections2 = const {
    'security': 'Sign-In and Security',
    'information': 'Personal Information',
    'payment': 'Payment Methods',
    'family': 'Family Sharing',
    'devices': 'Devices',
    'privacy': 'Privacy'
  };
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InfoAvatar(),
        const SizedBox(
          height: 48,
        ),
        ...sections2.entries
            .mapIndexed(
          (index, e) => SideMenuItem(
            title: e.value,
            selected: index == selectedIndex,
            onPressed: () {
              widget.onPressed(index);
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        )
            .fold(
          [],
          (previousValue, element) =>
              previousValue.toList() + [element, const SizedBox(height: 16)],
        ),
        /*...sections
            .mapIndexed(
          (index, title) => SideMenuItem(
            title: title,
            selected: index == selectedIndex,
            onPressed: () {
              widget.onPressed(index);
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        )
            .fold(
          [],
          (previousValue, element) =>
              previousValue.toList() + [element, const SizedBox(height: 16)],
        )*/
      ],
    );
  }
}
