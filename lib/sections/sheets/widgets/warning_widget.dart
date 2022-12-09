// ignore_for_file: prefer_constructors_over_static_methods

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

  static Warning warning([String? text]) {
    return Warning(
      view: DecoratedBox(
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
              Flexible(
                child: Text(
                  text ??
                      'Перед тем как оформить заказ, узнайте о наличии продукта в интернет-магазине',
                  style: AppStyles.h2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Warning advertisment({
    String? name,
    String? link,
    String? description,
  }) {
    return Warning(
      view: DecoratedBox(
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
            children: [
              Text(
                name ?? 'Онлайн-кинотеатр',
                style: AppStyles.h1,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                link ?? 'more.tv',
                style: AppStyles.p1Underlined,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                description ??
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
