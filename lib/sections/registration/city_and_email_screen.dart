import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/default_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CityAndEmailScreen extends StatefulWidget {
  const CityAndEmailScreen({Key? key}) : super(key: key);

  @override
  State<CityAndEmailScreen> createState() => _CityAndEmailScreenState();
}

class _CityAndEmailScreenState extends State<CityAndEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isValidated = false;
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 40),
                child: Text(
                  'Отлично, осталось выбрать город и указать электронную почту',
                  style: AppStyles.h1,
                ),
              ),
              DefaultTextFormField(
                labelText: 'Город',
                controller: cityController,
                inputType: TextInputType.name,
                validator: (dynamic value) {
                  if (value == null || value.toString().isEmpty) {
                    return '123';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 4,
              ),
              DefaultTextFormField(
                labelText: 'E-mail',
                controller: emailController,
                inputType: TextInputType.emailAddress,
                validator: (dynamic value) {
                  if (value == null || value.toString().isEmpty) {
                    return '123';
                  }
                  return null;
                },
              ),
              if (!isValidated)
                Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    BlueButtonWithText(
                      text: 'Продолжить',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isValidated = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
              if (isValidated)
                Column(
                  children: const [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Мы почти у цели! На указанный E-mail отправлена ссылка, по которой необходимо перейти для подтверждения регистрации. Если письма нет, рекомендуем проверить папку «Спам».',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 20 / 14,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: isValidated
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: BlueButtonWithText(text: 'Готово'),
            )
          : Container(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
