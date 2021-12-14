import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/global/login/models/login_text.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class PhoneForm extends StatelessWidget {
  final LoginText loginText;
  final LoginWM wm;

  const PhoneForm({
    required this.wm,
    required this.loginText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NativeTextInput(
          labelText: 'Мобильный телефон',
          controller: wm.phoneController,
          inputType: TextInputType.phone,
          textStyle: AppStyles.h1,
          autofocus: true,
          inputFormatters: wm.phoneInputFormaters,
        ),
        const SizedBox(height: 4),
        StreamedStateBuilder<bool>(
          streamedState: wm.sendPhoneBtnActive,
          builder: (_, state) {
            return BlueButtonWithText(
              text: 'Продолжить',
              // ignore: unnecessary_lambdas
              onPressed: state ? () => wm.sendPhoneAction() : null,
            );
          },
        ),
        const SizedBox(
          height: 21,
        ),
        Transform.translate(
          offset: const Offset(-10, -10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamedStateBuilder<bool>(
                streamedState: wm.policyAccepted,
                builder: (_, val) {
                  return CustomCheckbox(
                    value: val,
                    onChanged: (_) {
                      wm.policyAcceptAction();
                    },
                  );
                },
              ),
              Flexible(
                child: Transform.translate(
                  offset: const Offset(0, 8),
                  child: loginText.linkText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
