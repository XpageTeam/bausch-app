import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';

final Map<String, Style> htmlStyles = {
  'a': Style(
    color: AppTheme.mineShaft,
    display: Display.INLINE,
    textDecoration: TextDecoration.none,
    border: const Border(
      bottom: BorderSide(
        color: AppTheme.mystic,
      ),
    ),
  ),
};