import 'package:flutter/material.dart';
import 'package:marathon/config/theme/app_theme.dart';
import 'package:marathon/screen/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Marathon',
            theme: AppTheme.light(context),
            darkTheme: AppTheme.light(context),
            themeMode: ThemeMode.light,
            home: HomeScreen(),
          );
        },
      ),
    );
  }
}
