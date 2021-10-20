import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class Warning extends StatelessWidget {
  final Widget view;
  const Warning({required this.view, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return view;
  }

  static Warning warning() {
    return Warning(
      view: Container(
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
      ),
    );
  }

  static Warning advertisment() {
    return Warning(
      view: Container(
        decoration: BoxDecoration(
          color: AppTheme.sulu,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 17,
            bottom: 30,
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Онлайн-кинотеатр',
                style: AppStyles.h2,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'data',
                style: AppStyles.p1Underlined,
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'Скачайте приложение и смотрите любимые фильмы в любое время',
                style: AppStyles.p1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}