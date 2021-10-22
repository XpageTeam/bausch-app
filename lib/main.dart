<<<<<<< HEAD
import 'dart:ui';

import 'package:bausch/sections/profile/profile_screen.dart';
=======
import 'package:bausch/sections/home/home_screen.dart';
>>>>>>> feature/home_page_animation
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme.currentAppTheme,
      home: const HomeScreen(),
    );
  }
}

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
          height: 150,
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

class RankWidget extends StatelessWidget {
  final String title;
  const RankWidget({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppTheme.sulu,
      ),
      child: Text(
        title,
        style: AppStyles.h1,
      ),
    );
  }
}