import 'package:bausch/models/sheet_model.dart';
import 'package:bausch/sections/sheets/main_navigation.dart';
import 'package:bausch/sections/sheets/overlay_navigation.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/points_info.dart';
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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MainNavigation(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              showSheet(context, Models.sheets[0]);
            },
            child: Text(Models.sheets[0].title),
          ),
          TextButton(
            onPressed: () {
              showSheet(context, Models.sheets[1]);
            },
            child: Text(Models.sheets[1].title),
          ),
          TextButton(
            onPressed: () {
              showSheet(context, Models.sheets[2]);
            },
            child: Text(Models.sheets[2].title),
          ),
          TextButton(
            onPressed: () {
              showSheet(context, Models.sheets[3]);
            },
            child: Text(Models.sheets[3].title),
          ),
          TextButton(
            onPressed: () {
              showSheet(context, Models.sheets[4]);
            },
            child: Text(Models.sheets[4].title),
          ),
          TextButton(
            onPressed: () {
              showSheet(context, Models.sheets[5]);
            },
            child: Text(Models.sheets[5].title),
          ),
        ],
      ),
    );
  }

  void showSheet(BuildContext context, SheetModel model) {
    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: calculatePercentage(model.models.length),
      maxHeight: 0.95,
      context: context,
      builder: (context, controller, d) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: PointsInfo(
                      text: '500',
                      backgoundColor: AppTheme.mystic,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: OverlayNavigation(
                  controller: controller,
                  sheetModel: model,
                ),
              ),
            ],
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
