import 'dart:ui';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HalfBluredCircle extends StatelessWidget {
  static const sigmaX = 10.0;
  static const sigmaY = 5.0;

  final double height;
  final String? text;
  final TextStyle? textStyle;

  const HalfBluredCircle({
    this.height = 100,
    this.text,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: sigmaX * 2.5,
              vertical: sigmaY * 2.5,
            ),
            child: Container(
              height: height,
              width: height,
              decoration: BoxDecoration(
                color: AppTheme.turquoiseBlue,
                borderRadius: BorderRadius.circular(
                  180,
                ),
              ),
            ),
          ),
          Positioned(
            top: (sigmaY * 2.5) / 2,
            left: 0,
            height: height + sigmaY * 2.5,
            width: height / 2 + sigmaX * 2.5,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: sigmaX,
                  sigmaY: sigmaY,
                ),
                child: ColoredBox(
                  color: AppTheme.sulu.withOpacity(0.3),
                ),
              ),
            ),
          ),
          if (text != null)
            Positioned.fill(
              child: Align(
                child: AutoSizeText(
                  text!,
                  maxLines: 1,
                  style: textStyle,
                ),
              ),
            ),

          // SizedBox(
          //   height: 50,
          //   child: ClipRRect(
          //     child: BackdropFilter(
          //       filter: ImageFilter.blur(
          //         sigmaX: 20,
          //         sigmaY: 20,
          //       ),
          //       child: Container(
          //         color: AppTheme.sulu.withOpacity(0.3),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
