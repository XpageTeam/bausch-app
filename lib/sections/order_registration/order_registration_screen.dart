import 'package:bausch/models/catalog_item/product_item_model.dart';

import 'package:bausch/sections/order_registration/sections/delivery_address_section.dart';
import 'package:bausch/sections/order_registration/sections/lens_parameters_section.dart';
import 'package:bausch/sections/order_registration/sections/order_items_section.dart';
import 'package:bausch/sections/order_registration/sections/recipient_section.dart';
import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/bloc/lens_bloc.dart';
import 'package:bausch/sections/profile/profile_settings/lens_parameters/lens_parameters_buttons_section.dart';
import 'package:bausch/sections/sheets/screens/free_packaging/final_free_packaging.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  final LensBloc lensBloc = LensBloc();

  @override
  void dispose() {
    lensBloc.close();
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
                BlocProvider(
                  create: (context) => lensBloc,
                  child: BlocBuilder<LensBloc, LensState>(
                    builder: (context, state) {
                      debugPrint(state.toString());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20,
                            ),
                            child: Text(
                              'Параметры',
                              style: AppStyles.h1,
                            ),
                          ),
                          const LensParametersButtonsSection(),
                          const SizedBox(
                            height: 36,
                          ),
                        ],
                      );
                    },
                  ),
                ),

                //* Область "Адрес доставки"
                DeliveryAddressSection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: StreamedStateBuilder<bool>(
        streamedState: wm.loadingState,
        builder: (_, isLoading) {
          return isLoading
              ? const CustomFloatingActionButton(
                  text: '',
                  icon: AnimatedLoader(),
                )
              : CustomFloatingActionButton(
                  text: 'Потратить ${wm.productItemModel.price} б',
                  icon: Container(),
                  onPressed: wm.makeOrderAction,
                );
        },
      ),
    );
  }
}
