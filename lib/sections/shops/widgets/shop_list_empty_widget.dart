import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class ShopListEmptyBottomSheet extends StatelessWidget {
  const ShopListEmptyBottomSheet({Key? key}) : super(key: key);

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

          const Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Поблизости нет оптик',
                style: AppStyles.h2Bold,
              ),
            ),
          ),

          const Flexible(
            child: Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: Text(
                'К сожалению, в вашем городе нет подходящих оптик, но вы можете выбрать другой город.',
                style: AppStyles.p1,
              ),
            ),
          ),

          BlueButton(
            onPressed: () {
              // TODO(Nikolay): Реализовать кнопку в контейнере с магазином.
            },
            children: const [
              Text(
                'Хорошо',
                style: AppStyles.h2Bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
