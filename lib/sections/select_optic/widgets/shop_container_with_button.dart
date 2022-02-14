import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopContainerWithButton extends StatelessWidget {
  final OpticShop shop;
  final void Function(OpticShop shop) onOpticShopSelect;
  const ShopContainerWithButton({
    required this.shop,
    required this.onOpticShopSelect,
    Key? key,
  }) : super(
          key: key,
        );

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
                shop.title,
                style: AppStyles.h2Bold,
              ),
            ),
          ),

          //* Адрес
          Flexible(
            child: Text(
              shop.address,
              style: AppStyles.p1,
            ),
          ),

          //* Номера
          ...shop.phones
              .map(
                (phone) => Flexible(
                  child: GestureDetector(
                    onTap: () async {
                      final url = 'tel:${shop.phones}';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        await Future<dynamic>.error('Could not launch $url');
                      }
                    },
                    child: Text(
                      shop.phones[0],
                      style: AppStyles.p1.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.turquoiseBlue,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),

          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: BlueButton(
              onPressed: () => onOpticShopSelect(shop),
              children: const [
                Text(
                  'Выбрать оптику',
                  style: AppStyles.h2Bold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
