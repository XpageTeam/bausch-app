import 'package:bausch/sections/registration/code_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/select_widgets/custom_checkbox.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/material.dart';

//Registration / phone_number
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController controller = TextEditingController();
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Войти или создать профиль',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                height: 31 / 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 100,
                bottom: 4,
              ),
              child: DefaultTextInput(
                labelText: 'Мобильный телефон',
                controller: controller,
                inputType: TextInputType.phone,
                textStyle: AppStyles.h1,
                decoration: const InputDecoration(
                  prefix: Text(
                    '+7 ',
                  ),
                ),
              ),
            ),
            BlueButtonWithText(
              text: 'Продолжить',
              onPressed: () {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const CodeScreen();
                    },
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckbox(
                  value: isAgree,
                  onChanged: (val) {
                    setState(
                      () {
                        isAgree = val!;
                      },
                    );
                  },
                ),
                const Flexible(
                  child: Text(
                    'Я соглашаюсь с Условиями обработки персональных данных и Правилами программы',
                    style: AppStyles.p1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
