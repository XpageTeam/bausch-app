import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class ShopInfoBottomBar extends StatelessWidget {
  final ShopModel shopModel;
  final VoidCallback? closePressed;
  final VoidCallback? onPressed;
  final bool error;
  const ShopInfoBottomBar({
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
              onPressed: closePressed,
              icon: const Icon(
                Icons.close,
                color: AppTheme.mineShaft,
              ),
            ),
          ),

          //* Наименование магазина
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                error //! Пока что просто
                    ? 'Поблизости нет оптик'
                    : shopModel.title,
                style: AppStyles.h2Bold,
              ),
            ),
          ),

          //* Адрес и телефонный номер
          Flexible(
            child: Container(
              margin:
                  EdgeInsets.only(bottom: error ? 30 : 20), //! Пока что просто
              child: Text.rich(
                TextSpan(
                  text: error //! Пока что просто
                      ? 'К сожалению в вашем городе нет подходящих оптик, но вы можете выбрать другой город'
                      : '${shopModel.address}\n',
                  style: AppStyles.p1,
                  children: error //! Пока что просто
                      ? null
                      : [
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

          //* Информация
          if (!error)
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Скидка работает в любой из оптик сети',
                  style: AppStyles.p1.copyWith(color: Colors.black),
                ),
              ),
            ),

          //* Кнопка
          Container(
            margin: const EdgeInsets.only(bottom: 24),
            child: BlueButton(
              onPressed: onPressed,
              children: [
                Text(
                  error ? 'Хорошо' : 'Выбрать оптику',
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
