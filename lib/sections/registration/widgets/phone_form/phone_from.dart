import 'dart:async';

import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/global/login/models/login_text.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:url_launcher/url_launcher.dart';

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
        DefaultTextInput(
          labelText: 'Мобильный телефон',
          controller: wm.phoneController,
          inputType: TextInputType.phone,
          textStyle: AppStyles.h1,
          autofocus: true,
          // decoration: const InputDecoration(
          //   prefix: Text(
          //     '+7 ',
          //   ),
          // ),
          inputFormatters: [
            MaskTextInputFormatter(mask: '+7 (9##) ###-##-##'),
          ],
        ),
        StreamedStateBuilder<bool>(
          streamedState: wm.sendPhoneBtnActive,
          builder: (_, state) {
            return BlueButtonWithText(
              text: 'Продолжить',
              onPressed: state ? () => wm.sendPhoneAction() : null,
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
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
              child: loginText.linkText,
            ),
          ],
        ),
      ],
    );
  }
}
