import 'package:appleid_dashboard/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'side_menu/menu_item_type.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);
    final theme = ThemeData.from(
      colorScheme: colorScheme,
    );

    final textTheme = theme.textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
    return MaterialApp(
      title: 'Manage your Apple ID',
      theme: theme.copyWith(textTheme: textTheme),
      home: HomePage(tab: MenuItemType.security),
    );
  }
}
