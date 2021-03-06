// ignore_for_file: avoid_void_async, unused_local_variable

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileSettingsScreenWM extends WidgetModel {
  final BuildContext context;

  final selectedCityName = StreamedState<String?>(null);
  final selectedBirthDate = StreamedState<DateTime?>(null);
  final enteredEmail = StreamedState<String?>(null);

  final showBanner = StreamedState<bool>(false);

  //final emailController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = MaskedTextController(mask: '+7 000 000 00 00');

  final changeCityAction = StreamedAction<String?>();

  final confirmEmail = VoidAction();

  var tempName = '';
  var tempLastName = '';

  ProfileSettingsScreenWM({required this.context})
      : super(const WidgetModelDependencies());

  @override
  void onLoad() {
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
    super.onLoad();
  }

  @override
  void onBind() {
    final userWM = Provider.of<UserWM>(context, listen: false);

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

  void sendEmailConfirmation() async {
    final rh = RequestHandler();

    CustomException? error;

    try {
      final result =
          BaseResponseRepository.fromMap((await rh.post<Map<String, dynamic>>(
        '/user/email/confirm/',
      ))
              .data!);
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: '???????????? ?????? ?????????????????? ???????????? ???? ??????????????',
        subtitle: e.toString(),
      );
    } on DioError catch (e) {
      error = CustomException(
        title: '???????????? ?????? ???????????????? ??????????????',
        subtitle: e.toString(),
      );
      // ignore: unused_catch_clause
    } on SuccessFalse catch (e) {
      error = const CustomException(
        title: '??????-???? ?????????? ???? ??????',
      );
    }

    if (error != null) {
      showDefaultNotification(
        title: error.title,
        subtitle: error.subtitle,
      );
    } else {
      showDefaultNotification(
        title: '???????????? ?????? ?????????????????????????? ?????????? ?????????????? ????????????????????!',
        success: true,
      );
    }
  }

  void setValues() {
    try {
      final userWM = Provider.of<UserWM>(context, listen: false);

      selectedCityName.accept(userWM.userData.value.data!.user.city);
      selectedBirthDate.accept(userWM.userData.value.data!.user.birthDate);
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

  Future<void> sendUserData() async {
    final userWM = Provider.of<UserWM>(context, listen: false);

    await userWM.updateUserData(
      userWM.userData.value.data!.user.copyWith(
        email: enteredEmail.value,
        name: nameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        city: selectedCityName.value,
        birthDate: selectedBirthDate.value,
      ),
    );

    // ignore: use_build_context_synchronously
    //Navigator.of(context).pop();
  }

  void setCityName(String? cityName) {
    final userWM = Provider.of<UserWM>(context, listen: false);

    if (cityName != null) {
      userWM.updateUserData(
        userWM.userData.value.data!.user.copyWith(city: cityName),
        successMessage: '?????????? ?????????????? ??????????????',
      );
    }

    // selectedCityName.accept(cityName ?? userWM.userData.value.data!.user.city);
  }

  void setEmail(String? email) {
    final userWM = Provider.of<UserWM>(context, listen: false);

    enteredEmail.accept(email ?? userWM.userData.value.data!.user.email);
  }

  void setBirthDate(DateTime? birthDate) {
    final userWM = Provider.of<UserWM>(context, listen: false);

    debugPrint('date was changed');

    selectedBirthDate.accept(
      birthDate ?? userWM.userData.value.data!.user.birthDate,
    );

    showBanner.accept(true);
  }
}
