import 'dart:async';

import 'package:bausch/exceptions/response_parse_exeption.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/login/login_code_sender.dart';
import 'package:bausch/global/login/login_phone_sender.dart';
import 'package:bausch/global/login/models/auth_response_model.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/home/home_screen.dart';
import 'package:bausch/sections/registration/code_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio/dio.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mwwm/mwwm.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class LoginWM extends WidgetModel {
  final BuildContext context;

  final phoneController = MaskedTextController(
    mask: '+7 (900) 000-00-00',
    text: '+7 (9',
  );

  final codeController = TextEditingController();

  final policyAccepted = StreamedState<bool>(false);
  final sendPhoneBtnActive = StreamedState<bool>(false);
  final loginProcessedState = StreamedState<bool>(false);

  final authRequestResult = EntityStreamedState<AuthResponseModel>()..loading();

  final sendPhoneAction = VoidAction();
  final sendCodeAction = VoidAction();

  final policyAcceptAction = VoidAction();

  LoginWM({
    required WidgetModelDependencies baseDependencies,
    required this.context,
  }) : super(baseDependencies);

  @override
  void dispose() {
    // phoneController.dispose();
    // codeController.dispose();
    super.dispose();
  }

  @override
  void onLoad() {
    phoneController.addListener(_checkBtnActive);
    super.onLoad();
  }

  @override
  void onBind() {
    //* принятие пользовательского соглашения
    subscribe(
      policyAcceptAction.stream,
      (_) {
        policyAccepted.accept(!policyAccepted.value);
        _checkBtnActive();
      },
    );

    //* подписка на нажатие кнопки
    subscribe(sendPhoneAction.stream, (_) {
      _sendPhone().then((value) {
        Navigator.push<void>(
          Keys.mainNav.currentContext!,
          MaterialPageRoute(
            builder: (context) {
              return const CodeScreen();
            },
          ),
        );
      });
    });

    //* переключение состояния кнопки при отправке запроса
    subscribe(loginProcessedState.stream, (_) {
      sendPhoneBtnActive.accept(loginProcessedState.value);
      // TODO(Danil): показывать лоадер
    });

    subscribe(sendCodeAction.stream, (value) {
      _sendCode().then((value) {

        // TODO(Danil)
        final wm = Provider.of<AuthWM>(context, listen: false);

        wm.checkAuthAction();

        debugPrint(value);

        // Navigator.of(Keys.mainNav.currentContext!).pushAndRemoveUntil<void>(
        //   CupertinoPageRoute(
        //     builder: (context) => const HomeScreen(),
        //   ),
        //   (route) => false,
        // );
      });

      // TODO(Nikita): Заменить на pushNamed
      // Navigator.push<void>(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return const CityAndEmailScreen();
      //     },
      //   ),
      // );
    });

    super.onBind();
  }

  void _checkBtnActive() {
    if (phoneController.text.length == 18 && policyAccepted.value) {
      sendPhoneBtnActive.accept(true);
    } else {
      sendPhoneBtnActive.accept(false);
    }
  }

  Future<void> _sendPhone() async {
    unawaited(loginProcessedState.accept(true));
    unawaited(authRequestResult.loading());

    try {
      final res = await PhoneSender.send(phoneController.text);

      await authRequestResult.content(res);
    } on DioError catch (e) {
      // TODO(Danil): вывести ошибку
    } on ResponseParseException catch (e) {
      // TODO(Danil): вывести ошибку
    } on SuccessFalse catch (e) {
      // TODO(Danil): вывести ошибку
    }

    unawaited(loginProcessedState.accept(false));
  }

  Future<String?> _sendCode() async {
    unawaited(loginProcessedState.accept(true));

    try {
      final res = await CodeSender.send(
        code: codeController.text,
        isMobilePhoneConfirmed:
            authRequestResult.value.data?.isMobilePhoneConfirmed ?? false,
      );

      await UserWriter.writeToken(res.xApiToken);

      return res.xApiToken;
    } on DioError catch (e) {
      // TODO(Danil): вывести ошибку
    } on ResponseParseException catch (e) {
      // TODO(Danil): вывести ошибку
    } on SuccessFalse catch (e) {
      // TODO(Danil): вывести ошибку
    }

    unawaited(loginProcessedState.accept(false));
  }
}
