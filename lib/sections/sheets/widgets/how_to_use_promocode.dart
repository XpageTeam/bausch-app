import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class HowToUsePromocode extends StatelessWidget {
  final String? text;
  const HowToUsePromocode({
    this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Как воспользоваться промокодом',
          style: AppStyles.h1,
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          text ??
              'Положите в корзину выбранный при заказе поощрения продукт. При оформлении заказа введите промокод '
                  'в поле «Промокод» и нажмите «Применить». Итоговая стоимость со скидкой отобразится в корзине.',
          style: AppStyles.p1,
        ),
      ],
    );
  }
}
