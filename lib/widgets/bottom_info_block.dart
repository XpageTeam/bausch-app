import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  const InfoBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 36,
      ),
      //height: 60,
      color: AppTheme.mystic,
      child: SafeArea(
        child: Center(
          child: Text(
            'Имеются противопоказания, необходимо проконсультироваться со специалистом',
            style: AppStyles.p1Grey,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
