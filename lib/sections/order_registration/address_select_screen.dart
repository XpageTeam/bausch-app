import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/order_registration/order_address_screen.dart';
import 'package:bausch/sections/order_registration/widget_models/address_select_screen_wm.dart';
import 'package:bausch/sections/order_registration/widget_models/order_registration_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class AddressSelectScreenArguments {
  final List<AdressModel> userAdresses;
  final ProductItemModel productItemModel;
  final OrderRegistrationScreenWM orderRegistrationScreenWM;

  AddressSelectScreenArguments({
    required this.userAdresses,
    required this.productItemModel,
    required this.orderRegistrationScreenWM,
  });
}

class AddressSelectScreen extends CoreMwwmWidget<AddressSelectScreenWM>
    implements AddressSelectScreenArguments {
  @override
  final List<AdressModel> userAdresses;
  @override
  final ProductItemModel productItemModel;
  @override
  final OrderRegistrationScreenWM orderRegistrationScreenWM;

  AddressSelectScreen({
    required this.userAdresses,
    required this.productItemModel,
    required this.orderRegistrationScreenWM,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => AddressSelectScreenWM(
            context: context,
            addressesList: userAdresses,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<AddressSelectScreenWM>, AddressSelectScreenWM>
      createWidgetState() => _AddressSelectScreenState();
}

class _AddressSelectScreenState
    extends WidgetState<AddressSelectScreen, AddressSelectScreenWM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: 'Адрес доставки',
        backgroundColor: AppTheme.mystic,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 4,
              ),
              child: StreamedStateBuilder<String?>(
                streamedState: wm.selectedCityName,
                builder: (_, cityName) {
                  return FocusButton(
                    labelText: 'Город',
                    selectedText: cityName,
                    onPressed: wm.setCityNameAction,
                  );
                },
              ),
            ),
            Flexible(
              child: StreamedStateBuilder<List<AdressModel>>(
                streamedState: wm.filteredAddressesList,
                builder: (_, addressesList) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (_, i) {
                      final address = addressesList[i];

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 4,
                        ),
                        child: FocusButton(
                          labelText: 'Адрес',
                          selectedText: '${address.street}, ${address.house}',
                          onPressed: () {
                            wm.addressSelectAction(
                              address,
                              // OrderAddressScreenArguments(
                              //   adress: address,
                              //   productItemModel: widget.productItemModel,
                              //   orderRegistrationScreenWM:
                              //       widget.orderRegistrationScreenWM,
                              // ),
                            );
                          },
                        ),
                      );
                    },
                    itemCount: addressesList.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
