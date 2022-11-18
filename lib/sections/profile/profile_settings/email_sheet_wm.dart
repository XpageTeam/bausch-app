import 'dart:async';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class EmailSheetWM extends WidgetModel {
  final BuildContext context;

  final emailController = TextEditingController();

  final formValidationState = StreamedState<bool>(false);
  final isLoading = StreamedState<bool>(false);

  final confirmSended = StreamedState<bool>(false);

  final sendConfirm = VoidAction();

  late UserWM userWM;

  EmailSheetWM({required this.context})
      : super(const WidgetModelDependencies());

  @override
  void onBind() {
    userWM = Provider.of<UserWM>(context, listen: false);

    emailController
      ..text = userWM.userData.value.data!.user.pendingEmail ??
          userWM.userData.value.data!.user.email ??
          ''
      ..addListener(_validateForm);

    sendConfirm.bind((_) {
      sendUserData();
    });

    _validateForm();

    super.onBind();
  }

  @override
  void dispose() {
    super.dispose();

    emailController.dispose();
  }

  Future<void> sendUserData() async {
    if (isLoading.value) return;
    final userWM = Provider.of<UserWM>(context, listen: false);

    final appsFlyer = Provider.of<AppsflyerSdk>(context, listen: false);

    await isLoading.accept(true);

    await userWM.updateUserData(
      userWM.userData.value.data!.user.copyWith(
        email: emailController.text,
      ),
    );

    await confirmSended.accept(true);
    Future.delayed(
      const Duration(milliseconds: 50),
      () => Navigator.of(context).pop(),
    );

    await isLoading.accept(false);

    unawaited(appsFlyer.logEvent('emailChanged', null));
    unawaited(AppMetrica.reportEvent('emailChanged'));
  }

  void _validateForm() {
    if (EmailValidator.validate(emailController.text) &&
        !emailController.text.trim().contains(RegExp('[А-Яа-я]'))) {
      formValidationState.accept(true);
    } else {
      formValidationState.accept(false);
    }
  }

  // void _validateForm() {
  //   const emailPattern = r'^[^@]+@[^@.]+\.[^@]+$';

  //   if (RegExp(emailPattern).hasMatch(emailController.text) &&
  //       emailController.text != userWM.userData.value.data?.user.email &&
  //       emailController.text != userWM.userData.value.data?.user.pendingEmail) {
  //     formValidationState.accept(true);
  //   } else {
  //     formValidationState.accept(false);
  //   }
  // }
}
