import 'package:bausch/models/sheets/sheet_with_items_model.dart';
import 'package:bausch/navigation/main_navigation.dart';
import 'package:bausch/navigation/overlay_navigation_with_items.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/loading/loading_screen.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

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
