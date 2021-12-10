import 'dart:async';

import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CityEmailScreenWM extends WidgetModel {
  final BuildContext context;

  final selectedCityName = StreamedState<String?>(null);

  final emailFieldController = TextEditingController();
  // final emailConfirmText = EntityStreamedState<String>();
  // final emailConfirmed = EntityStreamedState<bool>();

  // final confirmEmailAction = VoidAction();

  final formValidationState = StreamedState<bool>(false);

  final setUserDataAction = VoidAction();

  CityEmailScreenWM({
    required this.context,
    String? cityName,
    String? email,
  }) : super(const WidgetModelDependencies()) {
    selectedCityName.accept(cityName);
    emailFieldController.text = email ?? '';
  }

  @override
  void onBind() {
    // subscribe(confirmEmailAction.stream, (value) {
    //   _confirmUserEmail();
    // });

    subscribe(setUserDataAction.stream, (value) {
      _setUserCityAndEmail();
    });

    subscribe<String?>(selectedCityName.stream, (value) {
      _validateForm();
    });

    emailFieldController.addListener(_validateForm);

    super.onBind();
  }

  @override
  void dispose() {
    emailFieldController.dispose();

    super.dispose();
  }

  void setCityName(String? cityName) {
    selectedCityName.accept(cityName);
  }

  // TODO(Danil): вывести лоадер
  Future<void> _setUserCityAndEmail() async {
    final userWM = Provider.of<UserWM>(context, listen: false);

    if (await userWM.updateUserData(userWM.userData.value.data!.user.copyWith(
      email: emailFieldController.text,
      city: selectedCityName.value,
    ))) {
      unawaited(
        Keys.mainContentNav.currentState!.pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
        ),
      );
    }
  }

  void _validateForm() {
    const phonePattern = r'^[^@]+@[^@.]+\.[^@]+$';

    if (selectedCityName.value != null &&
        selectedCityName.value != '' &&
        RegExp(phonePattern).hasMatch(emailFieldController.text)) {
      formValidationState.accept(true);
    } else {
      formValidationState.accept(false);
    }
  }

  // Future<void> _confirmUserEmail() async {
  //   final userWM = Provider.of<UserWM>(context, listen: false);

  //   try {
  //     await userWM.updateUserData(userWM.userData.value.data!.user.copyWith(
  //       email: emailFieldController.text,
  //     ));
  //   } on DioError catch (e) {
  //     debugPrint(e.toString());
  //   } on ResponseParseException catch (e) {
  //     debugPrint(e.toString());
  //   } on SuccessFalse catch (e) {
  //     debugPrint(e.toString());
  //   }
  // }
}
