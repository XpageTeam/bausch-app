import 'dart:ui';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/addresses/widgets/address_switcher.dart';
import 'package:bausch/sections/addresses/widgets/shop_info_bottom_bar.dart';
import 'package:bausch/sections/addresses/widgets/shop_list_widget.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//* Макет:
//* Program
//* list
class AddressesScreen extends StatefulWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  //* Пока что это такие заглушки
  bool toggleValue = false;
  bool _bottomBarVisible = false;
  bool _bottomBarWasVisible = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        appBar: const DefaultAppBar(
          title: 'Адреса оптик',
          backgroundColor: AppTheme.mystic,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
            vertical: 18,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              //* Переключатель
              AddressesSwitcher(
                margin: const EdgeInsets.only(bottom: 20),
                switcherCallback: (rightValue) => setState(
                  () {
                    toggleValue = rightValue;

                    //* Тоже заглушка. Потом по-другому это будет реализовано
                    if (rightValue) {
                      if (_bottomBarVisible) {
                        _bottomBarWasVisible = true;
                      }
                      _bottomBarVisible = false;
                    } else {
                      if (_bottomBarWasVisible) {
                        _bottomBarVisible = true;
                      }
                      _bottomBarWasVisible = false;
                    }
                  },
                ),
              ),

              //* Кнопка выбора города
              DefaultButton(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 18),
                onPressed: () {
                  setState(
                    () {
                      _bottomBarVisible = true;
                    },
                  );
                },
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
              if (toggleValue)
                ShopListWidget(
                  shopList: ShopModel.generate(6),
                ),
            ],
          ),
        ),

        //* Информация о выбранном магазине
        bottomNavigationBar: Visibility(
          visible: _bottomBarVisible,
          child: ShopInfoBottomBar(
            error: true,
            shopModel: ShopModel.test(),
            onPressed: () {},
            closePressed: () {
              setState(
                () {
                  _bottomBarVisible = false;
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
