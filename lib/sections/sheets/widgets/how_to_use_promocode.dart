import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class HowToUsePromocode extends StatelessWidget {
  const HowToUsePromocode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Как воспользоваться промокодом',
          style: AppStyles.h2,
        ),
        SizedBox(
          height: 12,
        ),
        Text(
          'Положите в корзину выбранный при заказе поощрения продукт. При оформлении заказа введите промокод в поле «Промокод» и нажмите «Применить». Итоговая стоимость со скидкой отобразится в корзине.',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            height: 20 / 14,
            fontSize: 14,
            color: AppTheme.mineShaft,
          ),
        ),
      ],
    );
  }
}