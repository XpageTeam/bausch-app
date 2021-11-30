// ignore_for_file: prefer_const_constructors

import 'package:bausch/sections/profile/profile_settings/profile_settings_screen_wm.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/inputs/default_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileSettingsScreen extends CoreMwwmWidget<ProfileSettingsScreenWM> {
  ProfileSettingsScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) =>
              ProfileSettingsScreenWM(context: context),
        );

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();

  @override
  WidgetState<CoreMwwmWidget<ProfileSettingsScreenWM>, ProfileSettingsScreenWM>
      createWidgetState() {
    // TODO: implement createWidgetState
    throw UnimplementedError();
  }
}

class _ProfileSettingsScreenState
    extends WidgetState<ProfileSettingsScreen, ProfileSettingsScreenWM> {
  // TextEditingController nameController = TextEditingController();
  // TextEditingController lastnameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController phoneController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // nameController.dispose();
    // lastnameController.dispose();
    // emailController.dispose();
    // phoneController.dispose();
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
          onPressed: () {
            wm.sendUserData();
          },
          child: Text(
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
                controller: wm.nameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: DefaultTextInput(
                labelText: 'Фамилия',
                controller: wm.lastNameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  DefaultTextInput(
                    labelText: 'E-mail',
                    controller: wm.emailController,
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
                controller: wm.phoneController,
                inputType: TextInputType.phone,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: StreamedStateBuilder<DateTime?>(
                streamedState: wm.selectedBirthDate,
                builder: (_, birthDate) {
                  return FocusButton(
                    labelText: 'Дата рождения',
                    selectedText: DateFormat('yyyy.MM.dd').format(birthDate!),
                    icon: Container(),
                    onPressed: () async {
                      wm.setBirthDate(await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900, 8),
                        lastDate: DateTime(2101),
                      ));
                    },
                  );
                },
              ),
            ),
            //*Зеленый виджет, есть в другой ветке
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: StreamedStateBuilder<String?>(
                streamedState: wm.selectedCityName,
                builder: (_, cityName) {
                  return FocusButton(
                    labelText: 'Город',
                    selectedText: cityName,
                    onPressed: () async {
                      wm.setCityName(
                        await Keys.mainNav.currentState!.push<String>(
                          PageRouteBuilder<String>(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    CityScreen(),
                          ),
                        ),
                      );
                    },
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
            Padding(
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
