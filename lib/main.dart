import 'package:bausch/navigation/main_navigation.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        // statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    return ScreenUtilInit(
      designSize: const Size(375, 799),
      builder: () => MaterialApp(
        title: 'Flutter Demo',
        navigatorKey: Keys.mainNav,
        theme: AppTheme.currentAppTheme,
        home: const MainNavigation(),
      ),
    );
  }
}
