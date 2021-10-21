import 'package:bausch/navigation/main_navigation.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Keys.mainNav,
      title: 'Flutter Demo',
      theme: AppTheme.currentAppTheme,
      home: MainNavigation(),
    );
  }
}
