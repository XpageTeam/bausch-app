// ignore_for_file: prefer_const_constructors

import 'package:bausch/sections/profile/profile_settings/city_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.mystic,
      appBar: DefaultAppBar(
        title: 'Настройки профиля',
        backgroundColor: AppTheme.mystic,
        topRightWidget: TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {},
          child: const Text(
            'Готово',
            style: AppStyles.p1Grey,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4, top: 30),
              child: DefaultTextInput(
                labelText: 'Имя',
                controller: nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: DefaultTextInput(
                labelText: 'Фамилия',
                controller: lastnameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  DefaultTextInput(
                    labelText: 'E-mail',
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(), // TODO(Nikita): Вывести статус
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: DefaultTextInput(
                labelText: 'Мобильный телефон',
                controller: phoneController,
                inputType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: DefaultTextInput(
                labelText: 'Дата рождения',
                controller: dateController,
                inputType: TextInputType.datetime,
              ),
            ),
            //*Зеленый виджет, есть в другой ветке
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FocusButton(
                labelText: 'Город',
                selectedText: 'Москва',
                onPressed: () {
                  Navigator.of(context).push<void>(
                    MaterialPageRoute(
                      builder: (context) {
                        return CityScreen();
                      },
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FocusButton(
                labelText: 'Мои адреса',
                onPressed: () {
                  Keys.mainContentNav.currentState!.pushNamed('/my_adresses');
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: FocusButton(
                labelText: 'Параметры контактных линз',
                onPressed: () {
                  Keys.mainContentNav.currentState!
                      .pushNamed('/lenses_parameters');
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: FocusButton(
                labelText: 'Привязать аккаунт',
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                'Версия приложения 10.6',
                style: AppStyles.p1Grey,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
