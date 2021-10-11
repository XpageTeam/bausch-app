import 'dart:ui';

import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/addresses/widgets/address_switcher.dart';
import 'package:bausch/sections/addresses/widgets/shop_info_bottom_bar.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
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
        body: Column(
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
              child: AddressesSwitcher(
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
            ),

            //! Сюда карту
            const Expanded(
              child: MapWithButtons(),
            ),
          ],
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

class MapWithButtons extends StatelessWidget {
  const MapWithButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(5),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // YandexMap(),

          Positioned(
            right: 15,
            bottom: 60,
            child: Column(
              children: [
                ChangeSizeButton(
                  zoomIn: () {},
                  zoomOut: () {},
                ),
                const SizedBox(
                  height: 152,
                ),
                CurrentLocationButton(
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChangeSizeButton extends StatelessWidget {
  final VoidCallback? zoomIn;
  final VoidCallback? zoomOut;
  const ChangeSizeButton({
    this.zoomIn,
    this.zoomOut,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppTheme.turquoiseBlue,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NormalIconButton(
            icon: const Icon(
              Icons.add,
              color: AppTheme.mineShaft,
            ),
            backgroundColor: AppTheme.turquoiseBlue,
            onPressed: zoomIn,
          ),
          NormalIconButton(
            icon: const Icon(
              Icons.remove,
              color: AppTheme.mineShaft,
            ),
            backgroundColor: AppTheme.turquoiseBlue,
            onPressed: zoomOut,
          ),
        ],
      ),
    );
  }
}

class CurrentLocationButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const CurrentLocationButton({
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NormalIconButton(
      icon: const Icon(
        Icons.location_on,
        color: AppTheme.mineShaft,
      ),
      onPressed: onPressed,
      backgroundColor: AppTheme.turquoiseBlue,
    );
  }
}
