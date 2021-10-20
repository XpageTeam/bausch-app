import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ShopContainer extends StatelessWidget {
  final ShopModel shop;
  const ShopContainer({
    required this.shop,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(StaticData.sidePadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shop.name,
            style: AppStyles.h2Bold,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            shop.address,
            style: AppStyles.p1,
          ),
          const SizedBox(
            height: 4,
          ),
          GestureDetector(
            onTap: () {
              // TODO(Nikolay): Реализовать нажатие по номеру телефона.
            },
            child: Text(
              shop.phone,
              style: AppStyles.p1.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppTheme.turquoiseBlue,
                decorationThickness: 2,
              ),
            ),
          ),
          if (shop.site != null) ...[
            const SizedBox(
              height: 4,
            ),
            GestureDetector(
              onTap: () {
                // TODO(Nikolay): Реализовать переход по ссылке.
              },
              child: Text(
                shop.site!,
                style: AppStyles.p1.copyWith(
                  decoration: TextDecoration.underline,
                  decorationColor: AppTheme.turquoiseBlue,
                  decorationThickness: 2,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
