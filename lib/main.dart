import 'package:bausch/models/sheet_model.dart';
import 'package:bausch/sections/sheets/overlay_navigation.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/points_info.dart';
import 'package:flutter/material.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import '/static/static_data.dart';

import 'test/models.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: Utils.mainAppNav,
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
      home: const MyHomePage(),
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
    showFlexibleBottomSheet(
      //useRootNavigator: true,
      minHeight: 0,
      initHeight: 0.8,
      maxHeight: 1,
      //anchors: [0, 0.5, 1],
      context: context,
      builder: (context, ScrollController controller, double d) {
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
                  )
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
}
