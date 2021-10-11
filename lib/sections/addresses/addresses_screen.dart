import 'dart:ui';

import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
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
class AddressesScreen extends StatelessWidget {
  const AddressesScreen({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            18,
            StaticData.sidePadding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AddressesSwitcher(
                margin: const EdgeInsets.only(bottom: 20),
                switcherCallback: (value) => debugPrint('$value'),
              ),

              //* Кнопка выбора города

              DefaultButton(
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

              //* Список адресов
              ShopListWidget(
                shopList: ShopModel.generate(6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef SwitcherCallback = void Function(bool value);

class AddressesSwitcher extends StatefulWidget {
  final SwitcherCallback? switcherCallback;
  final EdgeInsets margin;
  const AddressesSwitcher({
    this.switcherCallback,
    this.margin = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  @override
  _AddressesSwitcherState createState() => _AddressesSwitcherState();
}

class _AddressesSwitcherState extends State<AddressesSwitcher> {
  bool isList = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color(0xffcacecf), //! AppTheme.grey
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: DefaultToggleButton(
              text: 'На карте',
              color: isList ? Colors.transparent : Colors.white,
              onPressed: () {
                setState(() {
                  isList = false;

                  if (widget.switcherCallback != null) {
                    widget.switcherCallback!(isList);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: DefaultToggleButton(
              text: 'Список',
              color: isList ? Colors.white : Colors.transparent,
              onPressed: () {
                setState(() {
                  isList = true;

                  if (widget.switcherCallback != null) {
                    widget.switcherCallback!(isList);
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DefaultToggleButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback? onPressed;
  const DefaultToggleButton({
    required this.color,
    required this.text,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: color,
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        splashColor: AppTheme.mystic,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              text,
              style: AppStyles.h2Bold,
            ),
          ),
        ),
      ),
    );
  }
}

class ShopListWidget extends StatelessWidget {
  final List<ShopModel> shopList;
  const ShopListWidget({
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) => ShopWidget(
        shopItem: shopList[i],
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 4,
      ),
      itemCount: shopList.length,
    );
  }
}

class ShopWidget extends StatelessWidget {
  final ShopModel shopItem;
  const ShopWidget({
    required this.shopItem,
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
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 4),
            child: Text(
              shopItem.title,
              style: AppStyles.h2Bold,
            ),
          ),

          //* Адрес и номер
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(bottom: 20),
            child: Text.rich(
              TextSpan(
                text: '${shopItem.address}\n',
                style: AppStyles.p1,
                children: [
                  TextSpan(
                    text: shopItem.phone,
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

//* Заглушка
class ShopModel {
  final String title;
  final String address;
  final String phone;

  const ShopModel({
    required this.title,
    required this.address,
    required this.phone,
  });

  factory ShopModel.test() {
    return const ShopModel(
      title: 'ЛинзСервис',
      address: 'ул. Задарожная, д. 20, к. 2, ТЦ Океания',
      phone: '+7 920 325-62-26',
    );
  }

  static List<ShopModel> generate([int length = 3]) {
    return List<ShopModel>.generate(
      length,
      (i) => ShopModel.test(),
    );
  }
}
