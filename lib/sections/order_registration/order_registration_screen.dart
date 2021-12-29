import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';

import 'package:bausch/sections/order_registration/sections/delivery_address_section.dart';
import 'package:bausch/sections/order_registration/sections/lens_parameters_section.dart';
import 'package:bausch/sections/order_registration/sections/order_items_section.dart';
import 'package:bausch/sections/order_registration/sections/recipient_section.dart';
import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  //final LensBloc lensBloc = LensBloc();

  @override
  void dispose() {
    wm.lensBloc.close();
    super.dispose();
  }

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
          child: Provider(
            create: (context) {
              return wm;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Область со списком заказанных продуктов
                const OrderItemsSection(),

                //* Область "Получатель"
                const RecipientSection(),

                //* Область "Параметры линз"
                if (wm.productItemModel.specifications != null)
                  const LensParametersSection(),

                //* Область "Адрес доставки"
                const DeliveryAddressSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: StreamedStateBuilder<AdressModel?>(
        streamedState: wm.address,
        builder: (_, adress) {
          return StreamedStateBuilder<bool>(
            streamedState: wm.loadingState,
            builder: (_, isLoading) {
              return isLoading
                  ? const CustomFloatingActionButton(
                      text: '',
                      icon: AnimatedLoader(),
                    )
                  : CustomFloatingActionButton(
                      text: 'Потратить ${wm.productItemModel.priceToString} б',
                      icon: Container(),
                      onPressed: ((wm.nameController.text.isNotEmpty) ||
                                  (wm.lastNameController.text.isNotEmpty)) &&
                              adress != null
                          ? () {
                              wm.makeOrderAction();
                            }
                          : null,
                    );
            },
          );
        },
      ),
    );
  }
}
