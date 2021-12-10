import 'dart:ui';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class HalfBluredCircle extends StatelessWidget {
  final sigmaX = 10.0;
  final sigmaY = 5.0;

  final double height;
  final String? text;

  const HalfBluredCircle({
    this.height = 100,
    this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
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
                child: Container(
                  color: AppTheme.sulu.withOpacity(0.3),
                ),
              ),
            ),
          ),
          Center(
            child: text != null
                ? AutoSizeText(
                    text!,
                    maxLines: 1,
                    style: TextStyle(),
                  )
                : null,
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
