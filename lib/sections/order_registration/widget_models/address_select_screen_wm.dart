import 'package:bausch/global/user/user_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class AddressSelectScreenWM extends WidgetModel {
  final BuildContext context;

  final selectedCityName = StreamedState<String?>(null);

  AddressSelectScreenWM({
    required this.context,
  }) : super(const WidgetModelDependencies());

  @override
  void onBind() {
    final userWM = Provider.of<UserWM>(context, listen: false);

    selectedCityName.accept(userWM.userData.value.data!.user.city);

    super.onBind();
  }

  void setCityName(String? cityName) {
    final userWM = Provider.of<UserWM>(context, listen: false);

    selectedCityName.accept(cityName ?? userWM.userData.value.data!.user.city);
  }
}
