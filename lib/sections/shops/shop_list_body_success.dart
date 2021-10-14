import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/shops/providers/map_bloc_provider.dart';
import 'package:bausch/sections/shops/widgets/address_switcher.dart';
import 'package:bausch/sections/shops/widgets/map_with_buttons.dart';
import 'package:bausch/sections/shops/widgets/shop_list_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ShopScreenBodySuccess extends StatelessWidget {
  final pageController = PageController();
  final List<ShopModel> shopList;

  ShopScreenBodySuccess({
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //* Переключатель
        Padding(
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            18,
            StaticData.sidePadding,
            0,
          ),
          child: ShopPageSwitcher(
            margin: const EdgeInsets.only(bottom: 20),
            switcherCallback: (newPage) {
              pageController.jumpToPage(newPage.index);
            },
          ),
        ),

        //* Кнопка выбора города
        Padding(
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            18,
            StaticData.sidePadding,
            0,
          ),
          child: DefaultButton(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
            onPressed: () {},
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Город',
                    style: AppStyles.p1Grey,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Москва',
                    style: AppStyles.h2Bold,
                  ),
                ],
              ),
            ],
            chevronColor: AppTheme.mineShaft,
          ),
        ),

        //* Карта -> Список Магазинов
        Expanded(
          child: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: pageController,
            children: [
              MapWithButtons(
                shopList: shopList,
              ),
              ShopListWidget(
                shopList: shopList,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
