import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DeliveryInfoContainer extends StatelessWidget {
  const DeliveryInfoContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppTheme.sulu,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/substract.png',
                height: 18,
              ),
              const SizedBox(
                width: 12,
              ),
              const Flexible(
                child: Text(
                  'Доставка в течение 60 рабочих дней',
                  style: AppStyles.h2Bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
