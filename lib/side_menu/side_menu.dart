import 'package:appleid_dashboard/side_menu/info_avatar.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'menu_item_type.dart';
import 'side_menu_item.dart';

class SideMenu extends StatefulWidget {
  final ValueChanged<int> onPressed;
  final int selectedIndex;
  const SideMenu({Key? key, this.selectedIndex = 0, required this.onPressed})
      : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final sections = {
    MenuItemType.security.name: 'Sign-In and Security',
    MenuItemType.information.name: 'Personal Information',
    MenuItemType.payment.name: 'Payment Methods',
    MenuItemType.family.name: 'Family Sharing',
    MenuItemType.devices.name: 'Devices',
    MenuItemType.privacy.name: 'Privacy'
  };
  late int selectedIndex;
  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InfoAvatar(),
        const SizedBox(
          height: 48,
        ),
        ...sections.entries
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
      ],
    );
  }
}
