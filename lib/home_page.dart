import 'package:appleid_dashboard/router/routes.dart';
import 'package:appleid_dashboard/side_menu/sections/signin_and_security/signin_and_security_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'side_menu/sections/personla_information.dart/personal_information_page.dart';
import 'side_menu/side_menu.dart';
import 'shared/responsive.dart';

class HomePage extends StatefulWidget {
  final int index;

  HomePage({Key? key, required String tab})
      : index = indexFrom(tab),
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

  static int indexFrom(String tab) {
    switch (tab) {
      case 'information':
        return 1;
      case 'payment':
        return 2;
      case 'family':
        return 3;
      case 'devices':
        return 4;
      case 'privacy':
        return 5;
      case 'security':
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
              const SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...() {
                    return Responsive.isMobile(context) == false
                        ? [
                            SideMenu(
                              onPressed: ((index) {
                                _selectedIndex = index;
                                switch (index) {
                                  case 0:
                                    context.goNamed(
                                        Routes.signInAndSecurity.value);
                                    break;
                                  case 1:
                                    context.goNamed(
                                        Routes.personalInformation.value);
                                    break;
                                  case 2:
                                    context
                                        .goNamed(Routes.paymentMethods.value);
                                    break;
                                }
                              }),
                            ),
                            const SizedBox(
                              width: 128,
                            )
                          ]
                        : [];
                  }(),
                  Flexible(
                    child: SizedBox(
                      width: Responsive.isDesktop(context) ? 708 : 320,
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
