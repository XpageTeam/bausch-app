// ignore_for_file: cascade_invocations

import 'package:bausch/sections/auth/loading/animation_content.dart';
import 'package:bausch/sections/auth/loading/loading_animation.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iphone_has_notch/iphone_has_notch.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    final spaceBetween = (MediaQuery.of(context).size.width - 114.sp * 2) / 3;

    return Scaffold(
      backgroundColor: AppTheme.turquoiseBlue,
      // appBar: const EmptyAppBar(),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //* Анимация, запускается при инициализации экрана
          const Positioned.fill(
            child: LoadingAnimation(),
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
                      86.sp -
                      spaceBetween -
                      80.sp -
                      114.sp +
                      (IphoneHasNotch.hasNotch ? 70.sp : 0.sp),
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
