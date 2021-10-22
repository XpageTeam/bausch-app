import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

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
