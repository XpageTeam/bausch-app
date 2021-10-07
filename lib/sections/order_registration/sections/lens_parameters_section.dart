import 'package:bausch/sections/order_registration/widgets/margin.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class LensParametersSection extends StatelessWidget {
  const LensParametersSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Margin(
      margin: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Margin(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Параметры линз',
              style: AppStyles.h1,
            ),
          ),
          OrderButton(
            title: 'Диоптрии',
            textColor: AppTheme.grey,
            margin: EdgeInsets.only(bottom: 4),
          ),
          OrderButton(
            title: 'Цилиндр',
            textColor: AppTheme.grey,
            margin: EdgeInsets.only(bottom: 4),
          ),
          OrderButton(
            title: 'Ось',
            textColor: AppTheme.grey,
            margin: EdgeInsets.only(bottom: 4),
          ),
          OrderButton(
            title: 'Аддидация',
            textColor: AppTheme.grey,
            margin: EdgeInsets.only(bottom: 4),
          ),
        ],
      ),
    );
  }
}
