// ignore_for_file: prefer_const_constructors

import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/profile/profile_settings/email_screen.dart';
import 'package:bausch/sections/profile/profile_settings/profile_settings_screen_wm.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/profile/widgets/profile_settings_banner.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/dialogs/alert_dialog.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';

import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileSettingsScreen extends CoreMwwmWidget<ProfileSettingsScreenWM> {
  ProfileSettingsScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) =>
              ProfileSettingsScreenWM(context: context),
        );

  @override
  WidgetState<CoreMwwmWidget<ProfileSettingsScreenWM>, ProfileSettingsScreenWM>
      createWidgetState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState
    extends WidgetState<ProfileSettingsScreen, ProfileSettingsScreenWM> {
  late UserWM userWM;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //userWM = Provider.of<UserWM>(context);
  }

  @override
  Widget build(BuildContext context) {
    userWM = Provider.of<UserWM>(context);
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
            style: AppStyles.p1,
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
                  EntityStateBuilder<UserRepository>(
                    streamedState: userWM.userData,
                    builder: (_, userData) {
                      return userData.user.isEmailConfirmed != null &&
                              !userData.user.isEmailConfirmed!
                          ? Padding(
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
                            )
                          : Container();
                    },
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
                enabled: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: StreamedStateBuilder<DateTime?>(
                streamedState: wm.selectedBirthDate,
                builder: (_, birthDate) {
                  return FocusButton(
                    labelText: 'Дата рождения',
                    selectedText: birthDate != null
                        ? DateFormat('dd.MM.yyyy').format(birthDate)
                        : null,
                    icon: Container(),
                    onPressed: wm.selectedBirthDate.value == null
                        ? () {
                            DatePicker.showDatePicker(
                              context,
                              initialDateTime: DateTime.now(),
                              minDateTime: DateTime(1900, 8),
                              maxDateTime: DateTime(2101),
                              locale: DateTimePickerLocale.ru,
                              onCancel: () {},
                              onConfirm: (date, i) {
                                debugPrint('onchanged');

                                showModalBottomSheet<void>(
                                  context: Keys.mainNav.currentContext!,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      yesText: 'Продолжить',
                                      noText: 'Отмена',
                                      text:
                                          'После установки сменить дату рождения будет невозможно!',
                                      yesCallback: () {
                                        wm.setBirthDate(date);
                                        Navigator.of(context).pop();
                                      },
                                      noCallback: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },
                            );
                          }
                        : null,
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
              child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }

                  return Text(
                    'Версия приложения ${snapshot.data?.version} (${snapshot.data?.buildNumber})',
                    style: AppStyles.p1Grey,
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
