import 'package:appleid_dashboard/router/routes.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp.router(
      routerConfig: AppRouter.router,
      title: 'Manage your Apple ID',
      theme: theme.copyWith(
          textTheme: textTheme,
          iconTheme: IconThemeData(color: colorScheme.primary)),
    );
  }
}
