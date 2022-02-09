// ignore_for_file: avoid-returning-widgets
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class AppTheme {
  //цвета с макета
  static const turquoiseBlue = Color(0xFF60D7E2);
  static const sulu = Color(0xFFC5F663);
  static const mineShaft = Color(0xFF2D2D2D);
  static const mystic = Color(0xFFECF1F3);
  static const grey = Color(0xFF797B7C);
  static const mainFontName = 'Euclid Circular A';

  static const MaterialColor turquoiseBlueMaterial = MaterialColor(
    _turquoiseBluePrimaryValue,
    <int, Color>{
      50: Color(_turquoiseBluePrimaryValue),
      100: Color(_turquoiseBluePrimaryValue),
      200: Color(_turquoiseBluePrimaryValue),
      300: Color(_turquoiseBluePrimaryValue),
      400: Color(_turquoiseBluePrimaryValue),
      500: Color(_turquoiseBluePrimaryValue),
      600: Color(_turquoiseBluePrimaryValue),
      700: Color(_turquoiseBluePrimaryValue),
      800: Color(_turquoiseBluePrimaryValue),
      900: Color(_turquoiseBluePrimaryValue),
    },
  );
  static const int _turquoiseBluePrimaryValue = 0xFF60D7E2;

  static ThemeData get currentAppTheme => ThemeData(
        fontFamily: 'Euclid Circular A',
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
        primarySwatch: turquoiseBlueMaterial,

        // appBarTheme: const AppBarTheme(
        //   systemOverlayStyle: SystemUiOverlayStyle(
        //     statusBarColor: mystic,
        //     statusBarIconBrightness: Brightness.dark,
        //   ),
        // ),
      );
}

Widget? loadStateChangedFunction(ExtendedImageState state) {
  if (state.extendedImageLoadState == LoadState.loading) {
    return const SizedBox();
  }
}
