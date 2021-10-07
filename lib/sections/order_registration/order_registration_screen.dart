import 'package:bausch/models/order_registration/order_item.dart';
import 'package:bausch/sections/order_registration/sections/delivery_address_section.dart';
import 'package:bausch/sections/order_registration/sections/lens_parameters_section.dart';
import 'package:bausch/sections/order_registration/sections/recipient_section.dart';
import 'package:bausch/sections/order_registration/widgets/order_appbar.dart';
import 'package:bausch/sections/order_registration/widgets/order_item_list_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OrderRegistrationScreen extends StatelessWidget {
  const OrderRegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const OrderAppBar(title: 'Оформление заказа'),
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
              OrderItemsArea(
                orderItemList: OrderItem.generateList(),
              ),

              //* Область "Получатель"
              // TODO(Nikolay): Тут сделать в соответствии с макетом (со вторым).
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

class BlueButton extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onPressed;
  const BlueButton({
    required this.children,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: AppTheme.turquoiseBlue,
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class BottomBar extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onPressed;
  const BottomBar({
    required this.children,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          child: BlueButton(
            children: children,
            onPressed: onPressed,
          ),
        ),
        const ContraindicationsInfoWidget(),
      ],
    );
  }
}

class ContraindicationsInfoWidget extends StatelessWidget {
  const ContraindicationsInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(36, 8, 36, 19),
      child: Center(
        child: Flexible(
          child: Text(
            'Имеются противопоказания, необходимо проконсультироваться со специалистом',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.grey,
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 16 / 14,
            ),
          ),
        ),
      ),
    );
  }
}
