import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ProfileBackground extends StatelessWidget {
  const ProfileBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: Column(
        children: [
          const Text(
            'Саша',
            style: AppStyles.h1,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppTheme.sulu,
            ),
            child: const Text(
              'Классный друг',
              style: AppStyles.h1,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/offers-from-partners.png',
              height: 300,
            ),
          ),
        ],
      ),
    );
  }
}
