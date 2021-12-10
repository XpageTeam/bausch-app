import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/order_registration/widgets/delivery_info_container.dart';
import 'package:bausch/sections/order_registration/widgets/delivery_info_widget.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/profile/profile_settings/screens/add_address/add_adress_details_screen.dart';
import 'package:bausch/static/static_data.dart';
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
          onPressed: () => Keys.mainContentNav.currentState?.pushNamed(
            '/test_address_add',
            arguments: AddDetailsArguments(
              adress: AdressModel(
                city: 'Москва',
                street: 'Александра Чавчавадзе',
                house: '9',
              ),
              isFirstLaunch: false,
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
          onPressed: () =>
              Keys.mainContentNav.currentState?.pushNamed('/test_address_add'),
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
