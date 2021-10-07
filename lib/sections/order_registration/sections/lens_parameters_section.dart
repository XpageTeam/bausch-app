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
        children: [
          const Margin(
            margin: EdgeInsets.only(bottom: 20),
            child: Text(
              'Параметры линз',
              style: AppStyles.h1,
            ),
          ),
          OrderButton(
            onPressed: () {},
            margin: const EdgeInsets.only(bottom: 4),
            title: const Text(
              'Диоптрии',
              style: AppStyles.h2GreyBold,
            ),
            textColor: AppTheme.grey,
          ),
          OrderButton(
            onPressed: () {},
            margin: const EdgeInsets.only(bottom: 4),
            title: const Text(
              'Цилиндр',
              style: AppStyles.h2GreyBold,
            ),
            textColor: AppTheme.grey,
          ),
          OrderButton(
            onPressed: () {},
            margin: const EdgeInsets.only(bottom: 4),
            title: const Text(
              'Ось',
              style: AppStyles.h2GreyBold,
            ),
            textColor: AppTheme.grey,
          ),
          OrderButton(
            onPressed: () {},
            margin: const EdgeInsets.only(bottom: 4),
            title: const Text(
              'Аддидация',
              style: AppStyles.h2GreyBold,
            ),
            textColor: AppTheme.grey,
          ),
        ],
      ),
    );
  }
}
