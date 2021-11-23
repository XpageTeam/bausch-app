// ignore_for_file: cascade_invocations

import 'package:bausch/sections/auth/loading/animated_content.dart';
import 'package:bausch/sections/auth/loading/animation_content.dart';
import 'package:bausch/sections/auth/loading/loading_animation.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late Animation positionAnimation;
  late Animation blurHeightAnimation;
  late AnimationController controller;

  //* Анимация начнется примерно через 2 секунды после initState
  Interval interval = const Interval(0.9, 1.0, curve: Curves.easeInOut);

  double opacity = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    positionAnimation = Tween<double>(begin: 250.0, end: 0.0).animate(
      CurvedAnimation(parent: controller, curve: interval),
    );

    controller.addListener(() {
      setState(() {
        opacity = 1.0;
      });
    });

    controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.turquoiseBlue,
      appBar: const EmptyAppBar(
        overlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //* Анимация, запускается при инициализации экрана
          const LoadingAnimation(),

          //* В Rive пока не завезли эффекты, в том числе размытие
          //* Поэтому делаю Blur с помощью BackdropFilter
          // AnimatedBlur(
          //   animation: Tween<double>(
          //     begin: 0.0,
          //     end: MediaQuery.of(context).size.height * 0.7,
          //   ).animate(
          //     CurvedAnimation(parent: controller, curve: interval),
          //   ),
          // ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     AnimatedOpacity(
          //       duration: const Duration(seconds: 3),
          //       opacity: opacity,
          //       curve: Curves.easeInOut,
          //       child: AnimatedContent(
          //         animation: positionAnimation as Animation<double>,
          //       ),
          //     ),
          //   ],
          // ),
          DelayedAnimatedTranslateOpacity(
            offsetY: 120,
            delay: const Duration(milliseconds: 2200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  child: const AnimationContent(),
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height / 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
