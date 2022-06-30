import 'package:appleid_dashboard/side_menu/menu_item_type.dart';
import 'package:flutter/material.dart' hide AppBar;

import '../side_menu/side_menu.dart';
import 'app_bar.dart';
import 'personal_information.dart/personal_information_page.dart';
import 'signin_and_security/signin_and_security_page.dart';

class HomePage extends StatefulWidget {
  final int index;

  HomePage({Key? key, required MenuItemType tab})
      : index = indexFrom(tab),
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

  static int indexFrom(MenuItemType tab) {
    switch (tab) {
      case MenuItemType.information:
        return 1;
      case MenuItemType.payment:
        return 2;
      case MenuItemType.family:
        return 3;
      case MenuItemType.devices:
        return 4;
      case MenuItemType.privacy:
        return 5;
      case MenuItemType.security:
      default:
        return 0;
    }
  }
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppBar(),
              const SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SideMenu(
                    onPressed: ((index) {
                      _selectedIndex = index;
                    }),
                  ),
                  const SizedBox(
                    width: 128,
                  ),
                  Flexible(
                    child: SizedBox(
                      width: 708,
                      child: IndexedStack(
                          index: _selectedIndex,
                          children: const [
                            SignInAndSecurityPage(),
                            PersonalInformationPage()
                          ]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
