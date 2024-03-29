import 'dart:async';
import 'dart:developer';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/user/user_model/subscription_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/profile/profile_settings/email_bottom_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileSettingsScreenWM extends WidgetModel {
  final BuildContext context;

  final selectedCityName = StreamedState<String?>(null);
  final cities = StreamedState<String?>(null);
  final selectedBirthDate = StreamedState<DateTime?>(null);
  final enteredEmail = StreamedState<String?>(null);
  final showBanner = StreamedState<bool>(false);

  //final emailController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '+7 000 000 00 00');
  final changeCityAction = StreamedAction<String?>();
  final confirmEmail = VoidAction();
  late final UserWM userWM;
  List<SubscriptionModel> notificationsList = [];

  String tempName = '';
  String tempLastName = '';

  AppsflyerSdk? _appsflyer;

  ProfileSettingsScreenWM({required this.context})
      : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    userWM = context.read<UserWM>();

    nameController.addListener(
      () {
        tempName = nameController.text;
      },
    );

    lastNameController.addListener(
      () {
        tempLastName = lastNameController.text;
      },
    );

    _appsflyer = Provider.of<AppsflyerSdk>(context, listen: false);

    super.onLoad();
  }

  @override
  void onBind() {
    setValues();

    userWM.userData.bind((userData) {
      setValues();
    });

    changeCityAction.bind(setCityName);

    confirmEmail.bind((_) {
      sendEmailConfirmation();
    });

    super.onBind();
  }

  @override
  void dispose() {
    super.dispose();

    //emailController.dispose();
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
  }

  Future<void> sendEmailConfirmation() async {
    final rh = RequestHandler();

    CustomException? error;

    try {
      BaseResponseRepository.fromMap((await rh.post<Map<String, dynamic>>(
        '/user/email/confirm/',
      ))
          .data!);
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      error = CustomException(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
      // ignore: unused_catch_clause
    } on SuccessFalse catch (e) {
      error = const CustomException(
        title: 'что-то пошло не так',
      );
    }

    if (error != null) {
      showDefaultNotification(
        title: error.title,
        // subtitle: error.subtitle,
      );
    } else {
      showDefaultNotification(
        title: 'Письмо для подтверждения почты успешно отправлено!',
        success: true,
      );
    }
  }

  Future<bool> reloadUserData() async {
    return userWM.reloadUserData();
  }

  void updateNotifications(List<SubscriptionModel> notifications) {
    notificationsList.clear();
    notificationsList = [...notifications];
    // showDefaultNotification(
    //   title: 'Данные успешно обновлены',
    //   success: true,
    // );

    userWM.updateUserData(
      userWM.userData.value.data!.user,
      notifications: notificationsList,
    );

    Keys.mainContentNav.currentState!.pop();
  }

  void setValues() {
    try {
      selectedCityName.accept(userWM.userData.value.data!.user.city);
      selectedBirthDate.accept(userWM.userData.value.data!.user.birthDate);
      notificationsList = [...userWM.userData.value.data!.user.subscriptions];
      enteredEmail.accept(userWM.userData.value.data!.user.pendingEmail ??
          userWM.userData.value.data!.user.email);

      //emailController.text = userWM.userData.value.data!.user.email ?? '';
      nameController.text = userWM.userData.value.data!.user.name ?? tempName;
      lastNameController.text =
          userWM.userData.value.data!.user.lastName ?? tempLastName;
      phoneController.text = userWM.userData.value.data!.user.phone;
      if (selectedBirthDate.value != null) {
        showBanner.accept(true);
      }
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deleteAccount({
    required VoidCallback onSuccess,
  }) async {
    final rh = RequestHandler();

    CustomException? error;

    try {
      final userData = userWM.userData.value.data!;

      BaseResponseRepository.fromMap((await rh.post<Map<String, dynamic>>(
        '/faq/form/',
        data: FormData.fromMap(<String, dynamic>{
          'email': userData.user.email,
          'topic': 22,
          'question': 199,
          'fio': userData.userName,
          'phone': userData.user.phone,
        }),
      ))
          .data!);
      onSuccess();
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'Ошибка при обработке ответа от сервера',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      error = CustomException(
        title: 'Ошибка при отправке запроса',
        subtitle: e.toString(),
      );
      // ignore: unused_catch_clause
    } on SuccessFalse catch (e) {
      error = const CustomException(
        title: 'что-то пошло не так',
      );
    }

    if (error != null) {
      log('error: ${error.subtitle}');
      showDefaultNotification(
        title: error.title,
        // subtitle: error.subtitle,
      );
    }
  }

  void changeEmail() {
    showModalBottomSheet<num>(
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) {
        return Wrap(children: [EmailBottomSheet()]);
      },
    ).then(
      (value) {
        final email = userWM.userData.value.data!.user.pendingEmail ??
            userWM.userData.value.data!.user.email;
        return enteredEmail.accept(email);
      },
    );
  }

  Future<void> sendUserData() async {
    await userWM.updateUserData(
      userWM.userData.value.data!.user.copyWith(
        email: enteredEmail.value,
        name: nameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        city: selectedCityName.value,
        birthDate: selectedBirthDate.value,
        // subscriptions: notificationsList,
      ),
      notifications: notificationsList,
    );

    if (tempName != nameController.text) {
      unawaited(_appsflyer?.logEvent('nameChanged', null));
    }

    if (tempLastName != lastNameController.text) {
      unawaited(_appsflyer?.logEvent('lastNameChanged', null));
    }

    // ignore: use_build_context_synchronously
    //Navigator.of(context).pop();
  }

  void setCityName(String? cityName) {
    if (cityName != null) {
      selectedCityName.accept(cityName);
    }
    // final userWM = Provider.of<UserWM>(context, listen: false);

    // if (cityName != null) {
    //   userWM.updateUserData(
    //     userWM.userData.value.data!.user.copyWith(city: cityName),
    //     successMessage: 'Город успешно изменён',
    //   );
    // }

    // selectedCityName.accept(cityName ?? userWM.userData.value.data!.user.city);
  }

  void setEmail(String? email) {
    enteredEmail.accept(email ?? userWM.userData.value.data!.user.email);
  }

  void setBirthDate(DateTime? birthDate) {
    debugPrint('date was changed');

    selectedBirthDate.accept(
      birthDate ?? userWM.userData.value.data!.user.birthDate,
    );

    unawaited(_appsflyer?.logEvent('birthdayChanged', null));

    showBanner.accept(true);
  }
}
