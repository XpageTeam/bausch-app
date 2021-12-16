import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/authentication/auth_wm.dart';
import 'package:bausch/global/login/models/auth_response_model.dart';
import 'package:bausch/global/login/models/login_text.dart';
import 'package:bausch/global/login/requests/login_code_sender.dart';
import 'package:bausch/global/login/requests/login_phone_sender.dart';
import 'package:bausch/global/login/requests/login_text_downloader.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/registration/code_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mwwm/mwwm.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class LoginWM extends WidgetModel {
  final BuildContext context;

  /// Текст чекбокса согласия на обработку данных
  final loginText = EntityStreamedState<LoginText>();
  final loginTextLoadAction = VoidAction();

  final smsSendCounter = StreamedState<int>(0);
  final smsResendSeconds = StreamedState<int>(0);
  final smsSendAction = VoidAction();

  final phoneController = TextEditingController()..text = '+7 ';

  final phoneInputFormaters = <TextInputFormatter>[
    TextInputMask(
      mask: r'\+7 (\99) 999-99-99',
    ),
  ];

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
  }) : super(baseDependencies) {
    _loadText();
    debugPrint('loginConstructor');

    var prevPhoneValue = '';

    phoneController.addListener(() {
      if ((phoneController.text == '+7 (97' ||
              phoneController.text == '+7 (98' ||
              phoneController.text == '+7 (99') &&
          (prevPhoneValue == '+7 ' || prevPhoneValue == '')) {
        phoneController
          ..text = '+7 (9'
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: phoneController.text.length),
          );
      }

      if (phoneController.text == '') {
        phoneController
          ..text = '+7 '
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: phoneController.text.length),
          );
      }

      prevPhoneValue = phoneController.text;

      _checkBtnActive();
    });

    loginTextLoadAction.bind((value) {
      _loadText();
    });

    //* принятие пользовательского соглашения

    policyAcceptAction.bind((_) {
      policyAccepted.accept(!policyAccepted.value);
      _checkBtnActive();
    });

    authRequestResult.bind((value) {
      if (authRequestResult.value.isLoading) {
        return;
      }

      if (authRequestResult.value.hasError) {
        _showTopError(authRequestResult.value.error as CustomException);
      }

      if (authRequestResult.value.data != null) {
        Navigator.push<void>(
          Keys.mainNav.currentContext!,
          MaterialPageRoute(
            builder: (context) {
              return const CodeScreen();
            },
          ),
        );
        // debugPrint(context.toString());
        // Keys.mainContentNav.currentState!.pushNamed('/code');
      }
    });

    //* подписка на нажатие кнопки
    sendPhoneAction.bind((_) {
      _sendPhone().then((value) {});
    });

    //* переключение состояния кнопки при отправке запроса
    loginProcessedState.bind((_) {
      sendPhoneBtnActive.accept(!loginProcessedState.value);

      debugPrint(sendPhoneBtnActive.value.toString());

      // TODO(Danil): показывать лоадер
    });

    sendCodeAction.bind((_) {
      _sendCode();
    });

    smsSendCounter.bind((_) {
      if (smsSendCounter.value == 1) {
        _startResendTimer(30);
      } else if (smsSendCounter.value > 1) {
        _startResendTimer(300);
      }
    });
  }

  void _checkAuth() {
    Provider.of<AuthWM>(context, listen: false).checkAuthAction();
  }

  void _showTopError(CustomException ex) {
    showDefaultNotification(
      title: ex.title,
      subtitle: ex.subtitle,
    );
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
      await authRequestResult.content(
        await PhoneSender.send(phoneController.text),
      );

      await smsSendCounter.accept(smsSendCounter.value + 1);
    } on DioError catch (e) {
      await authRequestResult.error(
        CustomException(
          title: 'При отправке запроса произошла ошибка',
          subtitle: e.message,
          ex: e,
        ),
      );
    } on ResponseParseException catch (e) {
      await authRequestResult.error(
        CustomException(
          title: 'При чтении ответа от сервера произошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    } on SuccessFalse catch (e) {
      await authRequestResult.error(
        CustomException(
          title: 'Произошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    }

    unawaited(loginProcessedState.accept(false));
  }

  Future<void> _sendCode() async {
    unawaited(loginProcessedState.accept(true));

    CustomException? error;

    try {
      final res = await CodeSender.send(
        code: codeController.text,
        isMobilePhoneConfirmed:
            authRequestResult.value.data?.isMobilePhoneConfirmed ?? false,
      );

      await UserWriter.writeToken(res.xApiToken);

      _checkAuth();
    } on DioError catch (e) {
      error = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      error = CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    }

    if (error != null) {
      _showTopError(error);
    }

    unawaited(loginProcessedState.accept(false));
  }

  /// Загрузка текста обработки перс данных
  Future<void> _loadText() async {
    if (loginText.value.isLoading) return;

    unawaited(loginText.loading());

    try {
      await loginText.content(await LoginTextDownloader.load());
    } on DioError catch (e) {
      await loginText.error(
        CustomException(
          title: 'При отправке запроса произошла ошибка',
          subtitle: e.message,
          ex: e,
        ),
      );
    } on ResponseParseException catch (e) {
      await loginText.error(
        CustomException(
          title: 'При чтении ответа от сервера произошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    } on SuccessFalse catch (e) {
      await loginText.error(
        CustomException(
          title: 'Произошла ошибка',
          subtitle: e.toString(),
          ex: e,
        ),
      );
    }
  }

  void _startResendTimer(int seconds) {
    smsResendSeconds.accept(seconds);

    Timer.periodic(const Duration(seconds: 1), (timer) {
      smsResendSeconds.accept(smsResendSeconds.value - 1);

      if (smsResendSeconds.value <= 0) {
        timer.cancel();

        return;
      }
    });
  }
}

String getTimerBySeconds(int seconds) {
  if (seconds <= 0) {
    return '00:00';
  }

  final remainsSeconds = seconds % 60;
  final minutes = (seconds - remainsSeconds) ~/ 60;

  return '${minutes.toString().length < 2 ? 0 : ""}$minutes:${remainsSeconds.toString().length < 2 ? 0 : ""}$remainsSeconds';
}
