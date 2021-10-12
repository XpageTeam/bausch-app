import 'package:bausch/sections/loading/animated_content.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late Animation positionAnimation;
  late AnimationController controller;

  //* Анимация начнется примерно через 2 секунды после initState
  Interval interval = const Interval(0.7, 1.0, curve: Curves.easeInOut);

  double opacity = 0;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    positionAnimation = Tween<double>(begin: 250.0, end: 0.0)
        .animate(CurvedAnimation(parent: controller, curve: interval));

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
      body: SafeArea(
        child: Stack(
          children: [
            //* Анимация, запускается при инициализации экрана
            const RiveAnimation.asset(
              'assets/loading.riv',
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AnimatedOpacity(
                  duration: const Duration(seconds: 3),
                  opacity: opacity,
                  curve: interval,
                  child: AnimatedContent(
                    animation: positionAnimation as Animation<double>,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
