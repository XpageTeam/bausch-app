// ignore_for_file: prefer_const_constructors

import 'package:bausch/sections/profile/profile_settings/email_screen.dart';
import 'package:bausch/sections/profile/profile_settings/profile_settings_screen_wm.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/profile/widgets/profile_settings_banner.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
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
  @override
  void dispose() {
    super.dispose();
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
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4, top: 30),
            child: NativeTextInput(
              labelText: 'Имя',
              controller: wm.nameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: NativeTextInput(
              labelText: 'Фамилия',
              controller: wm.lastNameController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                StreamedStateBuilder<String?>(
                  streamedState: wm.enteredEmail,
                  builder: (_, email) {
                    return FocusButton(
                      labelText: 'E-mail',
                      selectedText: email,
                      icon: Container(),
                      onPressed: () async {
                        wm.setEmail(
                          await Keys.mainNav.currentState!.push<String>(
                            PageRouteBuilder<String>(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      EmailScreen(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                //if (!wm.isEmailConfirmed)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      DiscountInfo(
                        color: AppTheme.turquoiseBlue,
                        text: 'подтвердить',
                      ),
                    ],
                  ), // TODO(Nikita): Вывести статус
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: NativeTextInput(
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
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: const ProfileSettingsBanner(),
          ),
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
              'Версия приложения 0.0.1 (15)',
              style: AppStyles.p1Grey,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
