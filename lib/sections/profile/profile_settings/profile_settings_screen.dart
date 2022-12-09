import 'dart:async';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/order_registration/widgets/order_button.dart';
import 'package:bausch/sections/profile/profile_settings/profile_settings_screen_wm.dart';
import 'package:bausch/sections/profile/profile_settings/screens/city/city_screen.dart';
import 'package:bausch/sections/profile/profile_settings/screens/notifications_settings/notifications_settings_screen.dart';
import 'package:bausch/sections/profile/widgets/profile_settings_banner.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/anti_glow_behavior.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:bausch/widgets/dialogs/alert_dialog.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:bausch/widgets/inputs/native_text_input.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
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
  late AppsflyerSdk appsFlyer;

  @override
  Widget build(BuildContext context) {
    userWM = Provider.of<UserWM>(context);
    authWM = Provider.of<AuthWM>(context);
    appsFlyer = Provider.of<AppsflyerSdk>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.mystic,
      appBar: DefaultAppBar(
        title: 'Настройки профиля',
        backgroundColor: AppTheme.mystic,
        topRightWidget: TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          onPressed: () {
            wm.sendUserData();
          },
          child: const Text('Готово', style: AppStyles.p1),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
        ),
        child: ScrollConfiguration(
          behavior: const AntiGlowBehavior(),
          child: PullToRefreshNotification(
            refreshOffset: 60,
            maxDragOffset: 80,
            color: Colors.black,
            onRefresh: wm.reloadUserData,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                PullToRefreshContainer((info) {
                  return ClipRect(
                    child: SizedBox(
                      height: info?.dragOffset ?? 0,
                      child: const Center(
                        child: AnimatedLoader(),
                      ),
                    ),
                  );
                }),
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
                  child: EntityStateBuilder<UserRepository>(
                    streamedState: userWM.userData,
                    builder: (_, userData) => Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            StreamedStateBuilder<String?>(
                              streamedState: wm.enteredEmail,
                              builder: (_, email) => FocusButton(
                                labelText: 'E-mail',
                                selectedText: email,
                                greenCheckIcon:
                                    !((userData.user.isEmailConfirmed != null &&
                                            !userData.user.isEmailConfirmed!) ||
                                        userData.user.pendingEmail != null),
                                waitConfirmationIcon:
                                    (userData.user.isEmailConfirmed != null &&
                                            !userData.user.isEmailConfirmed!) ||
                                        userData.user.pendingEmail != null,
                                icon: Container(),
                                onPressed: wm.changeEmail,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if ((userData.user.isEmailConfirmed != null &&
                                          !userData.user.isEmailConfirmed!) ||
                                      userData.user.pendingEmail != null)
                                    GestureDetector(
                                      onTap: wm.sendEmailConfirmation,
                                      child: const DiscountInfo(
                                        text: 'Подтвердить',
                                        color: AppTheme.turquoiseBlue,
                                      ),
                                    ),
                                  if (!((userData.user.isEmailConfirmed !=
                                              null &&
                                          !userData.user.isEmailConfirmed!) ||
                                      userData.user.pendingEmail != null))
                                    GestureDetector(
                                      onTap: wm.changeEmail,
                                      child: const DiscountInfo(
                                        text: 'Изменить',
                                        color: AppTheme.mystic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if ((userData.user.isEmailConfirmed != null &&
                                !userData.user.isEmailConfirmed!) ||
                            userData.user.pendingEmail != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Warning.warning(
                              'Мы отправили инструкцию для  подтверждения. Проверьте почту.',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: NativeTextInput(
                    labelText: 'Мобильный телефон',
                    greenCheckIcon: true,
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
                          if (FocusScope.of(context).hasFocus) {
                            FocusScope.of(context).unfocus();
                          }
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
                StreamedStateBuilder<bool>(
                  streamedState: wm.showBanner,
                  builder: (_, showing) {
                    return showing
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: ProfileSettingsBanner(),
                          )
                        : const SizedBox();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: StreamedStateBuilder<String?>(
                    streamedState: wm.selectedCityName,
                    builder: (_, cityName) {
                      return FocusButton(
                        labelText: 'Партнеров из какого города показывать',
                        selectedText: cityName,
                        onPressed: () async {
                          await wm.changeCityAction(
                            await Keys.mainNav.currentState!.push<String?>(
                              PageRouteBuilder<String>(
                                pageBuilder: (_, __, ___) => CityScreen(
                                  withFavoriteItems: const ['Москва'],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 4),
                //   child: FocusButton(
                //     labelText: 'Мои адреса',
                //     onPressed: () {
                //       appsFlyer.logEvent('myAddressesOpened', null);
                //       Keys.mainContentNav.currentState!
                //           .pushNamed('/my_adresses');
                //     },
                //   ),
                // ),
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
                  padding: const EdgeInsets.only(bottom: 4),
                  child: FocusButton(
                    labelText: 'Уведомления',
                    selectedText: 'Акции, скидки, новости',
                    selectedTextStyle: AppStyles.p1Grey,
                    onPressed: () {
                      Keys.mainContentNav.currentState!.push(
                        PageRouteBuilder<String>(
                          pageBuilder: (_, __, ___) =>
                              NotificationsSettingsScreen(
                            valuesList: wm.notificationsList,
                            onSendUpdate: wm.updateNotifications,
                          ),
                        ),
                      );
                    },
                  ),
                ),
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
                      surfaceTintColor: Colors.transparent,
                    ),
                    child: Text(
                      'Выйти',
                      style: AppStyles.h2.copyWith(
                        color: AppTheme.grey,
                      ),
                    ),
                  ),
                ),
                WhiteButton(
                  text: 'Удалить аккаунт',
                  padding: const EdgeInsets.symmetric(
                    horizontal: StaticData.sidePadding,
                    vertical: 26,
                  ),
                  style: AppStyles.h2.copyWith(
                    color: const Color(
                      0xffFF7F77,
                    ),
                  ),
                  onPressed: () async {
                    _showDeleteAccountBottomSheet(confirmCallback: (ctx) async {
                      await wm.deleteAccount(onSuccess: () {
                        Navigator.of(ctx).pop();
                        _showSuccessBottomSheet(
                          confirmCallback: (c) => Navigator.of(c).pop(),
                        );
                      });
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 40),
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
        ),
      ),
    );
  }

  void _showDeleteAccountBottomSheet({
    required Future<void> Function(BuildContext) confirmCallback,
  }) {
    final isLoadingState = StreamedState(false);
    showFlexibleBottomSheet<void>(
      context: Keys.mainContentNav.currentContext!,
      minHeight: 0,
      initHeight: 0.4,
      maxHeight: 0.5,
      anchors: [0, 0.4, 0.5],
      bottomSheetColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context, controller, _) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                5,
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: AppTheme.mystic,
            body: Stack(
              children: [
                CustomScrollView(
                  scrollBehavior: const AntiGlowBehavior(),
                  controller: controller,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StaticData.sidePadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            const SizedBox(height: 40),
                            const Text(
                              'Удалить аккаунт',
                              style: AppStyles.h1,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            const Text(
                              'При удалении аккаунта все данные профиля и история накопления баллов будут безвозвратно удалены.',
                              style: AppStyles.p1Grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          height: 4,
                          width: 38,
                          decoration: BoxDecoration(
                            color: AppTheme.mineShaft,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  StreamedStateBuilder<bool>(
                    streamedState: isLoadingState,
                    builder: (_, isLoading) {
                      return BlueButtonWithText(
                        text: isLoading ? '' : 'Подтверждаю',
                        icon: isLoading ? const UiCircleLoader() : null,
                        onPressed: isLoading
                            ? null
                            : () async {
                                unawaited(isLoadingState.accept(true));
                                await confirmCallback(context);
                                unawaited(isLoadingState.accept(false));
                              },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  DefaultButton(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    children: const [
                      Text(
                        'Отмена',
                        style: AppStyles.h2Bold,
                      ),
                    ],
                    onPressed: Navigator.of(context).pop,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSuccessBottomSheet({
    required ValueChanged<BuildContext> confirmCallback,
  }) {
    showFlexibleBottomSheet<void>(
      context: Keys.mainContentNav.currentContext!,
      minHeight: 0,
      initHeight: 0.35,
      maxHeight: 0.45,
      anchors: [0, 0.35, 0.45],
      bottomSheetColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context, controller, _) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                5,
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: AppTheme.mystic,
            body: Stack(
              children: [
                CustomScrollView(
                  scrollBehavior: const AntiGlowBehavior(),
                  physics: const ClampingScrollPhysics(),
                  controller: controller,
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: StaticData.sidePadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          const [
                            SizedBox(height: 40),
                            Text(
                              'Заявка принята',
                              style: AppStyles.h1,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              'В течение 7 рабочих дней ваш аккаунт будет удален.',
                              style: AppStyles.p1Grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: IgnorePointer(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          height: 4,
                          width: 38,
                          decoration: BoxDecoration(
                            color: AppTheme.mineShaft,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  BlueButton(
                    children: const [
                      Text(
                        'Хорошо',
                        style: AppStyles.h2Bold,
                      ),
                    ],
                    onPressed: () => confirmCallback(context),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
