import 'package:bausch/sections/order_registration/address_select_screen.dart';
import 'package:bausch/sections/order_registration/widgets/delivery_info_container.dart';
import 'package:bausch/sections/order_registration/widgets/delivery_info_widget.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Адрес доставки',
          style: AppStyles.h1,
        ),
        const SizedBox(
          height: 20,
        ),

        OrderButton(
          // TODO(Nikolay): В адрес доставки.
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (ctx) {
                return const AddressSelectScreen();
              },
            ),
          ),

          title: Flexible(
            child: Text(
              'Москва, Александра Чавчавадзе, 9',
              style: AppStyles.h2Bold,
            ),
          ),
          icon: Icons.check_circle_sharp,
          margin: const EdgeInsets.only(bottom: 4),
        ),
        // TODO(Nikolay): В создание адреса доставки.
        OrderButton(
          onPressed: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (ctx) {
                return const AddressSelectScreen();
              },
            ),
          ),
          title: Text(
            'Добавить новый адрес',
            style: AppStyles.h2Bold,
          ),
          icon: Icons.add_circle_outline,
          margin: const EdgeInsets.only(bottom: 4),
        ),

        //* "Доставка может занять 60 рабочих дней"
        const DeliveryInfoContainer(),
        const SizedBox(
          height: 4,
        ),

        //* Информация о условиях доставки мелким шрифтом
        const DeliveryInfoWidget(),
      ],
    );
  }
}
