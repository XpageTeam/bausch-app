import 'package:bausch/models/order_registration/order_item.dart';
import 'package:bausch/sections/order_registration/sections/delivery_address_section.dart';
import 'package:bausch/sections/order_registration/sections/lens_parameters_section.dart';
import 'package:bausch/sections/order_registration/sections/order_items_section.dart';
import 'package:bausch/sections/order_registration/sections/recipient_section.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/final_free_packaging.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';

//* Макет
//* Catalog_free packaging:
//* order
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
        // topRightWidget: NormalIconButton(
        //   onPressed: () {},
        //   icon: const Icon(
        //     Icons.settings,
        //     color: AppTheme.mineShaft,
        //   ),
        // ),

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
      bottomNavigationBar: CustomFloatingActionButton(
        text: 'Потратить 1250 б',
        onPressed: () {
          //* TODO(Nikita): Заменить потом на pushNamed
          showFlexibleBottomSheet<void>(
            context: Keys.mainNav.currentContext!,
            minHeight: 0,
            initHeight: 0.7,
            maxHeight: 0.95,
            anchors: [0, 0.6, 0.95],
            builder: (context, controller, d) {
              return FinalFreePackaging(
                controller: controller,
                model: Models.items[0],
              );
            },
          );
          // showModalBottomSheet<void>(
          //   context: Keys.mainNav.currentContext!,
          //   isScrollControlled: true,
          //   builder: (context) {
          //     return FinalFreePackaging(
          //       controller: ScrollController(),
          //       model: Models.items[0],
          //     );
          //   },
          // );
        },
      ),
    );
  }
}
