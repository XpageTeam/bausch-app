import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  const InfoBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: StaticData.sidePadding,
        right: StaticData.sidePadding,
        top: 4,
        bottom: 19,
      ),
      //height: 60,
      color: AppTheme.mystic,
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Text(
            'Имеются противопоказания, необходимо\nпроконсультироваться со специалистом',
            style: AppStyles.p1Grey,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
