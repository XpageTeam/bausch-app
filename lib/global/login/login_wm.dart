import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class LoginWM extends WidgetModel {
  final BuildContext context;

  final phoneController = MaskedTextController(
    mask: '+7 (000) 000-00-00',
  );

  final codeController = TextEditingController();

  final policyAccepted = StreamedState<bool>(false);
  final sendPhoneBtnActive = StreamedState<bool>(false);

  final loginProcessedState = StreamedState<bool>(false);

  final sendPhone = VoidAction();
  final sendCode = VoidAction();
  final policyAcceptAction = VoidAction();

  LoginWM({
    required WidgetModelDependencies baseDependencies,
    required this.context,
  }) : super(baseDependencies);

  @override
  void dispose() {
    phoneController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  void onLoad() {
    phoneController.addListener(_checkBtnActive);
    super.onLoad();
  }

  @override
  void onBind() {
    subscribe(
      policyAcceptAction.stream,
      (_) {
        policyAccepted.accept(!policyAccepted.value);
        _checkBtnActive();
      },
    );

    super.onBind();
  }

  void _checkBtnActive() {
    if (phoneController.text.length == 18 && policyAccepted.value) {
      debugPrint('true');
      sendPhoneBtnActive.accept(true);
    } else {
      sendPhoneBtnActive.accept(false);
      debugPrint('false');
    }
  }
}

// String? phoneValidator(String? value) {
//   if (value == null || value.length <= 2) return 'логин дб не менее 2 символов';
  
//   return null;
// }