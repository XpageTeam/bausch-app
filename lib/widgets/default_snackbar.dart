import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DefaultSnackBar {
  static void show(
    BuildContext context, {
    required String title,
    String? text,
  }) {
    final snack = _makeSnackBar(
      context,
      title: title,
      text: text,
    );
    Overlay.of(context)?.insert(snack);
    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      snack.remove,
    );
  }

  // TODO(Nikolay): сделать анимацию появления/исчезновения.
  static OverlayEntry _makeSnackBar(
    BuildContext context, {
    required String title,
    String? text,
  }) {
    return OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Material(
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.mineShaft,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(5),
              ),
            ),

            //Colors.black,
            padding: const EdgeInsets.fromLTRB(
              StaticData.sidePadding,
              45,
              StaticData.sidePadding,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppStyles.p1White,
                ),
                if (text != null)
                  Text(
                    text,
                    style: AppStyles.p1White.copyWith(
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
