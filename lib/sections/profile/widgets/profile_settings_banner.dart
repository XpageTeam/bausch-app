import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ProfileSettingsBanner extends StatelessWidget {
  const ProfileSettingsBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 20, 21, 20),
      decoration: BoxDecoration(
        color: AppTheme.sulu,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icons/gift.png',
            width: 16,
          ),
          const SizedBox(
            width: 12,
          ),
          const Flexible(
            child: Text(
              'В День Рождения мы начислим в подарок 50 баллов.',
              style: AppStyles.h2Bold,
            ),
          ),
        ],
      ),
    );
  }
}
