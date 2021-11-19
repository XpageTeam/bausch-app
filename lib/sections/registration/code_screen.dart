import 'package:bausch/global/login/login_wm.dart';
import 'package:bausch/sections/registration/widgets/code_form/code_form.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class CodeScreen extends StatefulWidget {
  const CodeScreen({Key? key}) : super(key: key);

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  @override
  Widget build(BuildContext context) {
    final loginWM = Provider.of<LoginWM>(context);

    return Scaffold(
      backgroundColor: AppTheme.mystic,
      extendBody: true,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          child: CodeForm(
            wm: loginWM,
          ),
        ),
      ),
      floatingActionButton: StreamedStateBuilder<int>(
        streamedState: loginWM.smsResendSeconds,
        builder: (_, data) {
          if (data > 0) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 20,
              ),
              child: Text(
                'Повторная отправка через ${getTimerBySeconds(data)}',
                style: AppStyles.p1,
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                child: BlueButtonWithText(
                  text: 'Отправить заново',
                  // ignore: unnecessary_lambdas
                  onPressed: () {
                    loginWM.sendPhoneAction();
                  },
                ),
              ),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
