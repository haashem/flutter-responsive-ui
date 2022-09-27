import 'package:flutter/material.dart';

const _desktopMinSize = 1100;
const _tabletMinSize = 740;

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

// This size work fine on my design, maybe you need some customization depends on your design

  // This isMobile, isTablet, isDesktop helep us later
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < _tabletMinSize;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < _desktopMinSize &&
      MediaQuery.of(context).size.width >= _tabletMinSize;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= _desktopMinSize;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // If our width is more than 1100 then we consider it a desktop
    if (size.width >= _desktopMinSize) {
      return desktop;
    }
    // If width it less then 1100 and more then 740 we consider it as tablet
    else if (size.width >= _tabletMinSize && tablet != null) {
      return tablet!;
    }
    // Or less then that we called it mobile
    else {
      return mobile;
    }
  }
}
