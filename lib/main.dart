import 'package:bausch/sections/loading/loading_screen.dart';
import 'package:bausch/sections/profile/profile_screen.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:bausch/sections/sheets/main_navigation.dart';
import 'package:bausch/sections/sheets/overlay_navigation.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bottom_sheet/bottom_sheet.dart';

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
      home: const ProfileScreen(),
    );
  }
}


  void showSheet(BuildContext context, SheetModel model) {
    showFlexibleBottomSheet<void>(
      useRootNavigator: true,
      minHeight: 0,
      initHeight: calculatePercentage(model.models.length),
      maxHeight: 0.95,
      anchors: [0, 0.6, 0.95],
      context: context,
      builder: (context, controller, d) {
        return SheetWidget(
          child: OverlayNavigation(
            sheetModel: model,
            controller: controller,
          ),
        );
      },
    );
  }

  double calculatePercentage(int lenght) {
    switch (lenght ~/ 2) {
      case 1:
        return 0.5;
      case 2:
        return 0.8;
      default:
        return 0.9;
    }
  }
}
