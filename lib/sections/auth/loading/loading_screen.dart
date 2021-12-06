// ignore_for_file: cascade_invocations

import 'package:bausch/sections/auth/loading/animation_content.dart';
import 'package:bausch/sections/auth/loading/loading_animation.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.turquoiseBlue,
      appBar: const NewEmptyAppBar(
        overlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          //* Анимация, запускается при инициализации экрана
          const LoadingAnimation(),

          //* Контент с текстом и кнопкой
          DelayedAnimatedTranslateOpacity(
            offsetY: 120,
            delay: const Duration(milliseconds: 1600),
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
