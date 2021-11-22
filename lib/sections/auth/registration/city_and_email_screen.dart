// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/inputs/default_text_form_field.dart';
import 'package:bausch/widgets/select_widgets/dropdown_widget.dart';
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
  void dispose() {
    super.dispose();
    cityController.dispose();
    emailController.dispose();
    FocusScope.of(context).unfocus();
    
  }

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
              FocusButton(
                labelText: 'Город',
                onPressed: () {
                  Keys.mainContentNav.currentState!.pushNamed('/city');
                },
              ),
              const SizedBox(
                height: 4,
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  DefaultTextFormField(
                    labelText: 'E-mail',
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                    validator: (dynamic value) {
                      if (value == null || value.toString().isEmpty) {
                        return 'Не введён e-mail';
                      }
                      return null;
                    },
                  ),

                  //* Кнопка с колбеком
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: AppTheme.grey,
                      size: 20,
                    ),
                  ),
                ],
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
                            FocusScope.of(context).unfocus();
                          });
                        }
                      },
                    ),
                  ],
                ),
              //* Когда кнопка нажата и письмо отправлено
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
              child: BlueButtonWithText(
                text: 'Готово',
                onPressed: () {
                  Keys.mainContentNav.currentState!.pushNamed('/home');
                },
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
