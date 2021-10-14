import 'package:flutter/material.dart';

class AppTheme {
  //цвета с макета
  static const turquoiseBlue = Color(0xFF60D7E2);
  static const sulu = Color(0xFFC5F663);
  static const mineShaft = Color(0xFF2D2D2D);
  static const mystic = Color(0xFFECF1F3);
  static const grey = Color(0xFF797B7C);

  static ThemeData get currentAppTheme => ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: turquoiseBlue,
          selectionColor: turquoiseBlue,
          selectionHandleColor: turquoiseBlue,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.zero,
          isDense: true,
          border: InputBorder.none,
        ),
        scaffoldBackgroundColor: mystic,

        // appBarTheme: const AppBarTheme(
        //   systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: mystic,
        //     statusBarIconBrightness: Brightness.dark,
        //   ),
        // ),
      );
}
