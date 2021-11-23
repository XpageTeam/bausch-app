import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DeliveryInfoContainer extends StatelessWidget {
  const DeliveryInfoContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppTheme.sulu,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.charging_station,
                color: AppTheme.mineShaft,
              ),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                child: Text(
                  'Доставка может занять 60 рабочих дней',
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
