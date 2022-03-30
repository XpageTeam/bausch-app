import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/packages/pin_code_fields/lib/pin_code_fields.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CodeForm extends StatelessWidget {
  final LoginWM wm;

  const CodeForm({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        StaticData.sidePadding,
        20,
        StaticData.sidePadding,
        0,
      ),
      // padding: EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Сообщение с кодом\nбыло отправлено на\n${wm.phoneController.text}',
            style: AppStyles.h1,
          ),
          // SizedBox(
          //   height: MediaQuery.of(context).size.height < 450 ? 20 : 100,
          // ),
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
          StreamedStateBuilder<int>(
            streamedState: wm.smsResendSeconds,
            builder: (_, data) {
              if (data > 0) {
                return Container(
                  padding: const EdgeInsets.only(
                    bottom: 20,
                    //left: StaticData.sidePadding,
                    right: StaticData.sidePadding,
                  ),
                  width: MediaQuery.of(context).size.width,
                  //Повторная отправка через ${getTimerBySeconds(data)}',
                  child: RichText(
                    //textAlign: TextAlign.left,
                    text: TextSpan(
                      style: AppStyles.p1,
                      children: [
                        const TextSpan(
                          text: 'Повторная отправка через',
                        ),
                        TextSpan(
                          text: ' ${getTimerBySeconds(data)}',
                          style: AppStyles.p1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return TextButton(
                  child: const Text(
                    'Отправить новый код',
                    style: AppStyles.h2,
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: wm.resendSMSAction,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
