import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopInfoBottomSheet extends StatelessWidget {
  final ShopModel shopModel;
  final VoidCallback? closePressed;
  final VoidCallback? onPressed;
  final bool error;
  const ShopInfoBottomSheet({
    required this.shopModel,
    this.closePressed,
    this.onPressed,
    this.error = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        StaticData.sidePadding,
        4,
        StaticData.sidePadding,
        24,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //* Чёрная пимпочка
          Center(
            child: Container(
              height: 4,
              margin: const EdgeInsets.only(
                bottom: 2,
              ),
              width: MediaQuery.of(context).size.width / 9.87,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: AppTheme.mineShaft,
              ),
            ),
          ),

          //* Кнопка закрыть
          Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            child: NormalIconButton(
              backgroundColor: AppTheme.mystic,
              onPressed: Navigator.of(context).pop,
              icon: const Icon(
                Icons.close,
                color: AppTheme.mineShaft,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Название магазина
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(bottom: 16),
                child: Flexible(
                  child: Text(
                    shopModel.name,
                    style: AppStyles.h2Bold,
                  ),
                ),
              ),

              //* Адрес
              Flexible(
                child: Text(
                  shopModel.address,
                  style: AppStyles.p1,
                ),
              ),

              //* Номер
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: GestureDetector(
                  onTap: () async {
                    final url = 'tel:${shopModel.phone}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      await Future<dynamic>.error('Could not launch $url');
                    }
                  },
                  child: Flexible(
                    child: Text(
                      shopModel.phone,
                      style: AppStyles.p1.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppTheme.turquoiseBlue,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ),
              ),

              BlueButton(
                onPressed: () {
                  // TODO(Nikolay): Реализовать кнопку в контейнере с магазином.
                },
                children: const [
                  Text(
                    'Выбрать оптику',
                    style: AppStyles.h2Bold,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
