import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ButtonWithPoints extends StatelessWidget {
  final String price;
  const ButtonWithPoints({required this.price, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      style: TextButton.styleFrom(
        primary: AppTheme.grey,
        backgroundColor: AppTheme.mystic,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            price,
            style: AppStyles.h2Bold,
          ),
          const SizedBox(
            width: 4,
          ),
          const CircleAvatar(
            child: Text(
              'б',
              style: TextStyle(
                color: AppTheme.mineShaft,
                fontSize: 17,
                fontWeight: FontWeight.w500,
                height: 20 / 17,
              ),
            ),
            radius: 14,
            backgroundColor: AppTheme.turquoiseBlue,
          ),
        ],
      ),
    );
  }
}
