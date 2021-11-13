import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/global_providers.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/auth/loading/loading_screen.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/loader/loader_scren.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) {
        return AuthWM(const WidgetModelDependencies());
      },
      lazy: false,
      child: GlobalProviders(
        child: MaterialApp(
          title: 'Bausch + Lomb',
          navigatorKey: Keys.mainNav,
          theme: AppTheme.currentAppTheme,
          home: const LoaderScreen(),
        ),
      ),
    );
  }
}
