import 'package:bausch/sections/order_registration/widgets/order_appbar.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/order_registration/widgets/order_item_widget.dart';
import 'package:bausch/sections/order_registration/widgets/order_textinput.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OrderRegistrationPage extends StatelessWidget {
  const OrderRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const OrderAppBar(title: 'Оформление заказа'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 28,
          horizontal: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OrderItemWidget(
              title: 'Раствор Biotrue универсальный (300 мл)',
              points: '13 000',
              imgLink: 'wasd',
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'После совершения заказа у вас останется 100 баллов',
              style: AppStyles.h3,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'Получатель',
              style: AppStyles.h2,
            ),
            const SizedBox(
              height: 20,
            ),
            const OrderTextInput(label: 'Имя'),
            const OrderTextInput(label: 'Фамилия'),
            const OrderTextInput(label: 'E-mail'),
            const OrderTextInput(label: 'Мобильный телефон'),
            const SizedBox(
              height: 36,
            ),
            const Text(
              'Параметры линз',
              style: AppStyles.h2,
            ),
            const SizedBox(
              height: 20,
            ),
            const OrderButton(
              title: Text(
                'Диоптрии',
                style: AppStyles.h3Grey,
              ),
              iconColor: AppTheme.grey,
            ),
            const OrderButton(
              title: Text(
                'Цилиндр',
                style: AppStyles.h3Grey,
              ),
              iconColor: AppTheme.grey,
            ),
            const OrderButton(
              title: Text(
                'Ось',
                style: AppStyles.h3Grey,
              ),
              iconColor: AppTheme.grey,
            ),
            const OrderButton(
              title: Text(
                'Аддидация',
                style: AppStyles.h3Grey,
              ),
              iconColor: AppTheme.grey,
            ),
            const SizedBox(
              height: 36,
            ),
            const Text(
              'Адрес доставки',
              style: AppStyles.h2,
            ),
            const SizedBox(
              height: 20,
            ),
            OrderButton(
              title: Row(
                children: const [
                  Icon(Icons.check_circle_sharp),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Москва, Александра Чавчавадзе, 9 ',
                    style: AppStyles.h3,
                  ),
                ],
              ),
              iconColor: AppTheme.mineShaft,
            ),
            OrderButton(
              title: Row(
                children: const [
                  Icon(Icons.add_circle_outline),
                  SizedBox(
                    width: 12,
                  ),
                  Text(
                    'Добавить новый адрес',
                    style: AppStyles.h3,
                  ),
                ],
              ),
              iconColor: AppTheme.mineShaft,
            ),
            // InfoWidget()
          ],
        ),
      ),
    );
  }
}
