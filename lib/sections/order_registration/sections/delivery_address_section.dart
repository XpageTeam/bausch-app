import 'package:bausch/sections/order_registration/widgets/delivery_info_container.dart';
import 'package:bausch/sections/order_registration/widgets/delivery_info_widget.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DeliveryAddressSection extends StatelessWidget {
  const DeliveryAddressSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Адрес доставки',
          style: AppStyles.h1,
        ),
        SizedBox(
          height: 20,
        ),

        OrderButton(
          title: 'Москва, Александра Чавчавадзе, 9 ',
          icon: Icons.check_circle_sharp,
          textColor: AppTheme.mineShaft,
          margin: EdgeInsets.only(bottom: 4),
        ),
        OrderButton(
          title: 'Добавить новый адрес',
          icon: Icons.add_circle_outline,
          textColor: AppTheme.mineShaft,
          margin: EdgeInsets.only(bottom: 4),
        ),

        //* "Доставка может занять 60 рабочих дней"
        DeliveryInfoContainer(),
        SizedBox(
          height: 4,
        ),

        //* Информация о условиях доставки мелким шрифтом
        DeliveryInfoWidget(),
      ],
    );
  }
}
