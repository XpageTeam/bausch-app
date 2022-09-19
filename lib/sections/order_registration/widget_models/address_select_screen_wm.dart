import 'package:bausch/models/profile_settings/adress_model.dart';
// import 'package:bausch/sections/order_registration/order_address_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class AddressSelectScreenWM extends WidgetModel {
  final BuildContext context;

  final List<AdressModel> addressesList;

  final AdressModel? selectedAddress;

  final StreamedState<List<AdressModel>> filteredAddressesList;

  final selectedCityName = StreamedState<String?>(null);

  final setCityNameAction = VoidAction();

  final addressSelectAction = StreamedAction<AdressModel>();

  final citiesList = <String>[];

  AddressSelectScreenWM({
    required this.context,
    required this.addressesList,
    this.selectedAddress,
  })  : filteredAddressesList = StreamedState(addressesList),
        super(const WidgetModelDependencies()) {
    for (final address in addressesList) {
      if (citiesList.contains(address.cityAndSettlement)) {
        continue;
      }

      citiesList.add(address.cityAndSettlement);
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
                withFavoriteItems: citiesList.contains('Москва') ? null : [],
              ),
            ),
          )
          .then(_setCityName);
    });

    addressSelectAction.bind((address) {
      Navigator.of(context).pop(address);

      // Navigator.of(context).pushNamed(
      //   '/order_address',
      //   arguments: args,
      // );
    });

    selectedCityName.bind((cityName) {
      if (cityName != null) {
        _applyFilter(cityName);
      }
    });

    if (citiesList.isNotEmpty && selectedAddress == null) {
      selectedCityName.accept(citiesList[0]);
    }

    debugPrint(selectedAddress?.cityAndSettlement);

    if (selectedAddress != null) {
      selectedCityName.accept(citiesList
          .firstWhere((city) => city == selectedAddress?.cityAndSettlement));
    }

    super.onBind();
  }

  void _applyFilter(String cityName) {
    final addresses = <AdressModel>[];

    for (final address in addressesList) {
      if (address.cityAndSettlement == cityName) {
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
