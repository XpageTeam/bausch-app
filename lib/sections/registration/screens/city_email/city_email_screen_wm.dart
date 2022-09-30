import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CityEmailScreenWM extends WidgetModel {
  final BuildContext context;

  // final selectedCityName = StreamedState<String?>(null);
  final codeScreenAuthTrue = StreamedState<bool>(false);

  final emailFieldController = TextEditingController();
  // final emailConfirmText = EntityStreamedState<String>();
  // final emailConfirmed = EntityStreamedState<bool>();

  // final confirmEmailAction = VoidAction();

  final formValidationState = StreamedState<bool>(false);

  final setUserDataAction = VoidAction();

  AppsflyerSdk? appsFlyer;

  CityEmailScreenWM({
    required this.context,
    // String? cityName,
    String? email,
  }) : super(const WidgetModelDependencies()) {
    // selectedCityName.accept(cityName);
    emailFieldController.text = email ?? '';
    appsFlyer = Provider.of<AppsflyerSdk>(context, listen: false);
  }

  @override
  void onBind() {

    subscribe(setUserDataAction.stream, (value) {
      _setUserCityAndEmail();
      final currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    });

    // subscribe<String?>(selectedCityName.stream, (value) {
    //   _validateForm();
    // });

    emailFieldController.addListener(_validateForm);

    super.onBind();
  }

  @override
  void dispose() {
    emailFieldController.dispose();

    super.dispose();
  }
  /*
  void setCityName(String? cityName) {
    selectedCityName.accept(cityName);
  }*/

  
  Future<void> _setUserCityAndEmail() async {
    final userWM = Provider.of<UserWM>(context, listen: false);

    if (await userWM.updateUserData(userWM.userData.value.data!.user.copyWith(
      email: emailFieldController.text,
      // city: selectedCityName.value,
    ))) {
      await codeScreenAuthTrue.accept(true);
      unawaited(appsFlyer?.logEvent('addedEmail', null));
    }
  }

  void _validateForm() {
    const phonePattern = r'^[^@]+@[^@.]+\.[^@]+$';

    if (/*selectedCityName.value != null &&
        selectedCityName.value != '' &&*/
        RegExp(phonePattern).hasMatch(emailFieldController.text)) {
      formValidationState.accept(true);
    } else {
      formValidationState.accept(false);
    }
  }
}
