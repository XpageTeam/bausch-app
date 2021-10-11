import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation opacityAnimation;
  late Animation logoPositionAnimation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.5),
      ),
    );

    logoPositionAnimation = Tween(begin: 0.0, end: 50.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.5),
      ),
    );

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.turquoiseBlue,
      body: AnimatedBuilder(
        animation: controller,
        builder: _buildAnimation,
      ),
    );
  }

  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: logoPositionAnimation.value as double,
        ),
        Opacity(
          opacity: opacityAnimation.value as double,
          child: Column(
            children: [
              Image.asset(
                'assets/logo_white.png',
              ),
              const Text(
                'Friends',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  height: 31 / 24,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 26,
        ),
        Opacity(
          opacity: opacityAnimation.value as double,
          child: CircleAvatar(
            radius: 86,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
