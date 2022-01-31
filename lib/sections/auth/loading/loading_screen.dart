// ignore_for_file: cascade_invocations

import 'package:bausch/sections/auth/loading/animation_content.dart';
import 'package:bausch/sections/auth/loading/column_with_dynamic_duration.dart';
import 'package:bausch/sections/auth/loading/image_row.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:flutter/material.dart';
import 'package:iphone_has_notch/iphone_has_notch.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    final spaceBetween = (MediaQuery.of(context).size.width - 114 * 2) / 3;

    return Scaffold(
      backgroundColor: AppTheme.turquoiseBlue,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //* Анимация, запускается при инициализации экрана
          Positioned.fill(
            child: ColumnWithDynamicDuration(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 18,
                    right: 18,
                    bottom: 30,
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Image.asset(
                      'assets/loading/logo.png',
                    ),
                  ),
                ),
                const ImageRow(
                  firstImg: 'assets/loading/1.png',
                  secondImg: 'assets/loading/2.png',
                ),
                const ImageRow(
                  firstImg: 'assets/loading/3.png',
                  secondImg: 'assets/loading/4.png',
                ),
                const ImageRow(
                  firstImg: 'assets/loading/5.png',
                  secondImg: 'assets/loading/6.png',
                ),
              ],
            ),
          ),

          //* Контент с текстом и кнопкой
          DelayedAnimatedTranslateOpacity(
            offsetY: 120,
            delay: const Duration(milliseconds: 1800),
            animationDuration: const Duration(milliseconds: 500),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: const AnimationContent(),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.bottom -
                      MediaQuery.of(context).padding.top -
                      86 -
                      spaceBetween -
                      80 -
                      114 +
                      (IphoneHasNotch.hasNotch ? 70 : 0),
                  //height: 400.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
