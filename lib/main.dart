import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:bottom_sheet/bottom_sheet.dart';

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
      body: Center(
        child: TextButton(
            onPressed: () {
              showFlexibleBottomSheet(
                  minHeight: 0,
                  initHeight: 0.8,
                  maxHeight: 1,
                  //anchors: [0, 0.5, 1],
                  context: context,
                  builder: (context, ScrollController controller, double d) {
                    return Sheet(
                      controller: controller,
                      title: 'Бесплатная упаковка',
                    );
                  });
            },
            child: Text('data')),
      ),
    );
  }
}
