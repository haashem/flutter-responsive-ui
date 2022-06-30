import 'package:appleid_dashboard/router/routes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final router = AppRouter.router;

  MyApp({super.key});
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
    return MaterialApp.router(
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      title: 'Manage your Apple ID',
      theme: theme.copyWith(textTheme: textTheme),
    );
  }
}
