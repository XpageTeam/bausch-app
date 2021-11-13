import 'dart:ui';

import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BluredImage extends StatelessWidget {
  const BluredImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          'assets/status.png',
          width: 200,
        ),
        SizedBox(
          height: 165,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                color: AppTheme.turquoiseBlue.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
