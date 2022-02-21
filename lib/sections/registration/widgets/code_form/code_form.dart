import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/packages/pin_code_fields/lib/pin_code_fields.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CodeForm extends StatelessWidget {
  final LoginWM wm;

  const CodeForm({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Сообщение с кодом\nбыло отправлено на\n${wm.phoneController.text}',
          style: AppStyles.h1,
        ),
        const SizedBox(
          height: 100,
        ),
        SizedBox(
          height: 100,
          child: Center(
            child: PinCodeTextField(
              controller: wm.codeController,
              animationType: AnimationType.none,
              appContext: context,
              length: 4,
              autoFocus: true,
              onChanged: (str) {},
              enableActiveFill: true,
              // focusNode: focusNode,
              cursorColor: AppTheme.mineShaft,
              keyboardType: TextInputType.phone,
              onCompleted: (str) {
                // focusNode.unfocus();

                wm.sendCodeAction();
              },
              pinTheme: PinTheme(
                fieldHeight: 100,
                fieldWidth: 63,
                shape: PinCodeFieldShape.box,
                activeColor: Colors.white,
                borderWidth: 0,
                selectedColor: Colors.white,
                activeFillColor: Colors.white,
                selectedFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                inactiveColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
