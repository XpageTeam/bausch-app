import 'dart:async';

import 'package:bausch/global/user/user_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class EmailScreenWM extends WidgetModel {
  final BuildContext context;

  final emailController = TextEditingController();

  final formValidationState = StreamedState<bool>(false);
  final isLoading = StreamedState<bool>(false);

  final confirmSended = StreamedState<bool>(false);

  final sendConfirm = VoidAction();
  final buttonAction = VoidAction();

  bool isConfirmSended = false;

  EmailScreenWM({required this.context})
      : super(const WidgetModelDependencies());

  @override
  void onBind() {
    final userWM = Provider.of<UserWM>(context, listen: false);

    emailController
      ..text = userWM.userData.value.data!.user.pendingEmail ??
          userWM.userData.value.data!.user.email ??
          ''
      ..addListener(_validateForm);

    sendConfirm.bind((_) {
      sendUserData();
    });

    buttonAction.bind((_) {
      Navigator.of(context).pop(emailController.text);
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

    await isLoading.accept(true);

    await userWM.updateUserData(
      userWM.userData.value.data!.user.copyWith(
        email: emailController.text,
      ),
    );
    isConfirmSended = true;

    unawaited(confirmSended.accept(true));
    await isLoading.accept(false);
  }

  void _validateForm() {
    const emailPattern = r'^[^@]+@[^@.]+\.[^@]+$';

    if (RegExp(emailPattern).hasMatch(emailController.text)) {
      formValidationState.accept(true);
    } else {
      formValidationState.accept(false);
    }
  }
}
