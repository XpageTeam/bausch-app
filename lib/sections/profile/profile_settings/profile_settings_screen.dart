// ignore_for_file: prefer_const_constructors

import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/profile/profile_settings/email_screen.dart';
import 'package:bausch/sections/profile/profile_settings/profile_settings_screen_wm.dart';
import 'package:bausch/sections/profile/widgets/profile_settings_banner.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/dialogs/alert_dialog.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:flutter/material.dart';

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
  late AuthWM authWM;

  @override
  Widget build(BuildContext context) {
    userWM = Provider.of<UserWM>(context);
    authWM = Provider.of<AuthWM>(context);

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
                textCapitalization: TextCapitalization.words,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: NativeTextInput(
                labelText: 'Фамилия',
                controller: wm.lastNameController,
                textCapitalization: TextCapitalization.words,
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
                            await Keys.mainContentNav.currentState!
                                .push<String>(
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
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if ((userData.user.isEmailConfirmed != null &&
                                    !userData.user.isEmailConfirmed!) ||
                                userData.user.pendingEmail != null)
                              GestureDetector(
                                onTap: wm.confirmEmail,
                                child: DiscountInfo(
                                  text: 'подтвердить',
                                  color: AppTheme.turquoiseBlue,
                                ),
                              )
                            else
                              GestureDetector(
                                child: DiscountInfo(
                                  text: 'подтверждён',
                                  color: AppTheme.turquoiseBlue,
                                ),
                              ),
                          ],
                        ),
                      );
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
                    onPressed: () {
                      DatePicker.showDatePicker(
                        context,
                        initialDateTime: DateTime(2004),
                        minDateTime: DateTime(1900, 8),
                        maxDateTime: DateTime.now(),
                        locale: DateTimePickerLocale.ru,
                        onCancel: () {},
                        dateFormat: 'dd.MM.yyyy',
                        onConfirm: (date, i) {
                          debugPrint('onchanged');

                          wm.setBirthDate(date);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: const ProfileSettingsBanner(),
            ),
            /* Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: StreamedStateBuilder<String?>(
                streamedState: wm.selectedCityName,
                builder: (_, cityName) {
                  return FocusButton(
                    labelText: 'Город',
                    selectedText: cityName,
                    onPressed: () async {
                      await wm.changeCityAction(
                        await Keys.mainNav.currentState!.push<String?>(
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
            ), */
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: FocusButton(
                labelText: 'Мои адреса',
                onPressed: () {
                  Keys.mainContentNav.currentState!.pushNamed('/my_adresses');
                },
              ),
            ),
            /*Padding(
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
            ),*/
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    barrierColor: Colors.black.withOpacity(0.8),
                    builder: (context) {
                      return CustomAlertDialog(
                        text: 'Уходите?',
                        yesCallback: () {
                          authWM.logout();
                        },
                        noCallback: () {
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                  primary: Colors.transparent,
                ),
                child: Text(
                  'Выйти',
                  style: AppStyles.h2.copyWith(
                    color: AppTheme.grey,
                  ),
                ),
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
