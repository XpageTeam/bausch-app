import 'package:bausch/models/catalog_item/product_item_model.dart';

import 'package:bausch/sections/order_registration/sections/delivery_address_section.dart';
import 'package:bausch/sections/order_registration/sections/lens_parameters_section.dart';
import 'package:bausch/sections/order_registration/sections/order_items_section.dart';
import 'package:bausch/sections/order_registration/sections/recipient_section.dart';
import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/final_free_packaging.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//* Макет
//* Catalog_free packaging:
//* order

class OrderRegistrationScreenArguments {
  final ProductItemModel model;

  OrderRegistrationScreenArguments({required this.model});
}

class OrderRegistrationScreen extends CoreMwwmWidget<OrderRegistrationScreenWM>
    implements OrderRegistrationScreenArguments {
  @override
  final ProductItemModel model;
  OrderRegistrationScreen({required this.model, Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => OrderRegistrationScreenWM(
            context: context,
            productItemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<OrderRegistrationScreenWM>,
          OrderRegistrationScreenWM>
      createWidgetState() => _OrderRegistrationScreenState();
}

class _OrderRegistrationScreenState
    extends WidgetState<OrderRegistrationScreen, OrderRegistrationScreenWM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: const DefaultAppBar(
        backgroundColor: AppTheme.mystic,
        title: 'Оформление заказа',
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
                model: wm.productItemModel,
                points: wm.difference,
              ),

              //* Область "Получатель"
              RecipientSection(
                wm: wm,
              ),

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
          showFlexibleBottomSheet<void>(
            context: Keys.mainNav.currentContext!,
            minHeight: 0,
            initHeight: 0.9,
            maxHeight: 0.95,
            anchors: [0, 0.6, 0.95],
            builder: (context, controller, d) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  FinalFreePackaging(
                    controller: ScrollController(),
                    model: Models.discountOptics[0],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Container(
                      height: 4,
                      width: 38,
                      decoration: BoxDecoration(
                        color: AppTheme.mineShaft,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
