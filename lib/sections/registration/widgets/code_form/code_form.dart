import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/packages/pin_code_fields/lib/pin_code_fields.dart';
import 'package:bausch/sections/registration/screens/city_email/city_and_email_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CodeForm extends StatelessWidget {
  final LoginWM wm;

  const CodeForm({
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 800),
      builder: () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // 'SMS-код был отправлен\nна ${wm.phoneController.text}',

              'SMS-код был отправлен\nна +7 (900) 000-00-00',
              style: AppStyles.h1,
            ),
            SizedBox(
              height: 100.sp,
            ),
            SizedBox(
              height: 100,
              child: Center(
                child: PinCodeTextField(
                  controller: wm.codeController,
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

                    // wm.sendCodeAction();

                    Keys.mainNav.currentState!.pushAndRemoveUntil(
                      PageRouteBuilder<void>(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return CityAndEmailScreen();
                        },
                      ),
                      (route) => false,
                    );
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
      },
    );
  }
}
