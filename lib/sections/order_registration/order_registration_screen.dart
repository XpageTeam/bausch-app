import 'package:bausch/models/order_registration/order_item.dart';
import 'package:bausch/sections/order_registration/sections/delivery_address_section.dart';
import 'package:bausch/sections/order_registration/sections/lens_parameters_section.dart';
import 'package:bausch/sections/order_registration/sections/order_items_section.dart';
import 'package:bausch/sections/order_registration/sections/recipient_section.dart';
import 'package:bausch/sections/order_registration/widgets/bottom_bar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class OrderRegistrationScreen extends StatelessWidget {
  const OrderRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: DefaultAppBar(
        backgroundColor: AppTheme.mystic,
        title: 'Оформление заказа',

        //* Кнопка "Настройки"
        topRightWidget: NormalIconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.settings,
            color: AppTheme.mineShaft,
          ),
        ),

        //* Кнопка "Готово"
        // topRightWidget: TextButton(
        //   style: ButtonStyle(
        //     overlayColor: MaterialStateColor.resolveWith(
        //       (states) => AppTheme.turquoiseBlue,
        //     ),
        //     padding: MaterialStateProperty.resolveWith<EdgeInsets>(
        //       (states) => const EdgeInsets.symmetric(horizontal: 5),
        //     ),
        //     minimumSize: MaterialStateProperty.resolveWith<Size>(
        //       (states) => Size.zero,
        //     ),
        //   ),
        //   onPressed: () {},
        //   child: const Text(
        //     'Готово',
        //     style: AppStyles.p1,
        //   ),
        // ),

        //* Кнопка "Готово" (другая)
        // topRightWidget: GestureDetector(
        //   onTap: () {
        //     debugPrint('statement');
        //   },
        //   child: Container(
        //     padding: EdgeInsets.all(5),
        //     child: Text('Готово'),
        //   ),
        // ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            30,
            StaticData.sidePadding,
            40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Область со списком заказанных продуктов
              OrderItemsSection(
                orderItemList: OrderItem.generateList(),
              ),

              //* Область "Получатель"
              const RecipientSection(),

              //* Область "Параметры линз"
              const LensParametersSection(),

              //* Область "Адрес доставки"
              const DeliveryAddressSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(
        onPressed: () {},
        children: const [
          Text(
            'Добавить баллы',
            style: AppStyles.h2Bold,
          ),
        ],
      ),
    );
  }
}
