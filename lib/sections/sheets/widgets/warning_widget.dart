import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  const Warning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.sulu,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/substract.png',
              height: 16,
            ),
            const SizedBox(
              width: 12,
            ),
            const Flexible(
              child: Text(
                'Перед тем как оформить заказ, узнайте о наличие продукта в интернет-магазине',
                style: AppStyles.h3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
