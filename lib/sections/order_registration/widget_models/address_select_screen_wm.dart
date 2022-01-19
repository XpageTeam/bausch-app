import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/sections/order_registration/order_address_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class AddressSelectScreenWM extends WidgetModel {
  final BuildContext context;

  final List<AdressModel> addressesList;

  final StreamedState<List<AdressModel>> filteredAddressesList;

  final selectedCityName = StreamedState<String?>(null);

  final setCityNameAction = VoidAction();

  final addressSelectAction = StreamedAction<OrderAddressScreenArguments>();

  final citiesList = <String>[];

  AddressSelectScreenWM({
    required this.context,
    required this.addressesList,
  })  : filteredAddressesList = StreamedState(addressesList),
        super(const WidgetModelDependencies()) {
    // ignore: curly_braces_in_flow_control_structures
    for (final address in addressesList) {

      debugPrint(address.fullAddress+' '+address.street+' '+address.house.toString());

      if (citiesList.contains(address.city)) {
        continue;
      }

      if (address.city != null) {
        citiesList.add(address.city!);
      }
    }
  }

  @override
  void onBind() {
    setCityNameAction.bind((_) {
      Keys.mainNav.currentState!
          .push<String>(
            PageRouteBuilder<String>(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  CityScreen(
                citiesWithShops: citiesList,
              ),
            ),
          )
          .then(_setCityName);
    });

    addressSelectAction.bind((args) {
      Navigator.of(context).pushNamed(
        '/order_address',
        arguments: args,
      );
    });

    selectedCityName.bind((cityName) {
      debugPrint('Установлен город $cityName');
      if (cityName != null) {
        _applyFilter(cityName);
      }
    });

    if (citiesList.isNotEmpty) {
      selectedCityName.accept(citiesList[0]);
    }

    super.onBind();
  }

  void _applyFilter(String cityName) {
    final addresses = <AdressModel>[];

    for (final address in addressesList) {
      if (address.city == cityName) {
        addresses.add(address);
      }
    }

    filteredAddressesList.accept(addresses);
  }

  void _setCityName(String? cityName) {
    if (cityName != null) {
      selectedCityName.accept(cityName);
    }
  }
}
