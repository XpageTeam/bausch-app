import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  final double topPadding;
  const InfoBlock({
    this.topPadding = 4,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: StaticData.sidePadding,
        right: StaticData.sidePadding,
        top: topPadding,
        bottom: 19,
      ),
      //height: 60,
      color: AppTheme.mystic,
      child: const SafeArea(
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
