import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ShopWidget extends StatelessWidget {
  final ShopModel shopModel;
  const ShopWidget({
    required this.shopModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(StaticData.sidePadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          //* Название магазина
          Flexible(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 4),
              child: Text(
                shopModel.name,
                style: AppStyles.h2Bold,
              ),
            ),
          ),

          //* Адрес и номер
          Flexible(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(bottom: 20),
              child: Text.rich(
                TextSpan(
                  text: '${shopModel.address}\n',
                  style: AppStyles.p1,
                  children: [
                    TextSpan(
                      text: shopModel.phone,
                      style: AppStyles.p1.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.turquoiseBlue,
                        decorationThickness: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          BlueButton(
            onPressed: () {},
            children: const [
              Text(
                'Выбрать оптику',
                style: AppStyles.h2Bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
