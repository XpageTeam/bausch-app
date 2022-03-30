import 'dart:async';
import 'dart:io';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/help/utils.dart';
import 'package:bausch/models/add_points/add_points_model.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/sheets/screens/add_points/final_add_points.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/dialogs/alert_dialog.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class AddPointsDetailsWM extends WidgetModel {
  final BuildContext context;
  final AddPointsModel addPointsModel;

  final loadingState = StreamedState<bool>(false);

  final buttonEnabledState = StreamedState<bool>(false);

  final colorState = StreamedState<Color>(AppTheme.mystic);

  final linkController = TextEditingController();

  final buttonAction = VoidAction();

  late UserWM userWm;

  AddPointsDetailsWM({
    required this.context,
    required this.addPointsModel,
  }) : super(const WidgetModelDependencies());

  @override
  void onBind() {
    buttonAction.bind((_) {
      if (addPointsModel.type == 'review' ||
          addPointsModel.type == 'review_social') {
        //* Если открыта клавиатура
        if (FocusScope.of(context).hasFocus) {
          FocusScope.of(context).unfocus();
        }

        showModalBottomSheet<void>(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
          barrierColor: Colors.black.withOpacity(0.8),
          builder: (context) {
            return CustomAlertDialog(
              text: StaticData.maxFilesSizeText,
              yesText: 'Прикрепить файл',
              noText: 'Отмена',
              yesCallback: () {
                Navigator.of(context).pop();
                _btnAction();
              },
              noCallback: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      } else {
        _btnAction();
      }
    });

    if (addPointsModel.type == 'review_social') {
      unawaited(
        FirebaseAnalytics.instance.logEvent(name: 'soc_review_show'),
      );
    }

    if (addPointsModel.type == 'review') {
      unawaited(FirebaseAnalytics.instance.logEvent(name: 'review_show'));
    }

    if (addPointsModel.type == 'vk') {
      unawaited(FirebaseAnalytics.instance.logEvent(name: 'vk_show'));
    }

    if (addPointsModel.type == 'invite_friend') {
      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'invite_friend_show',
        ),
      );
    }

    if (addPointsModel.type == 'review' ||
        addPointsModel.type == 'review_social') {
      linkController.addListener(() {
        if (linkController.text.isEmpty) {
          buttonEnabledState.accept(false);
        } else {
          buttonEnabledState.accept(true);
        }
      });
    } else {
      buttonEnabledState.accept(true);
    }
    super.onBind();
  }

  @override
  void onLoad() {
    userWm = Provider.of<UserWM>(
      context,
      listen: false,
    );
    super.onLoad();
  }

  Future<void> _btnAction() async {
    switch (addPointsModel.type) {
      case 'review':
        await _addPoints(
          '/review/save/',
          linkController.text,
        );
        break;
      case 'review_social':
        await _addPoints(
          '/review/soc/save/',
          linkController.text,
        );
        break;
      case 'vk':
        await _launchVKUrl(addPointsModel.url);
        break;
      case 'invite_friend':
        unawaited(
          FirebaseAnalytics.instance.logEvent(
            name: 'invite_friend_share',
          ),
        );
        await Utils.tryShare(text: addPointsModel.url);
        break;
    }
  }

  Future<void> _launchVKUrl(String? url) async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    try {
      await AddPointsSaver.beforeLaunchVKUrl();

      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'vk_subscribe_click',
        ),
      );
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
        title: e.toString(),
        ex: e,
      );
    }

    unawaited(loadingState.accept(false));

    if (error != null) {
      showDefaultNotification(
        title: error.title,
        subtitle: error.subtitle,
      );
    } else {
      await Utils.tryLaunchUrl(
        rawUrl: url ?? '',
        onError: (ex) {
          showDefaultNotification(
            title: ex.title,
            subtitle: ex.subtitle,
          );
        },
      );
    }
  }

  Future<void> _addPoints(String link, String reviewLink) async {
    unawaited(loadingState.accept(true));

    CustomException? error;
    String? message;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: Platform.isAndroid ? FileType.custom : FileType.image,
        allowedExtensions: Platform.isAndroid ? StaticData.fileTypes : null,
      );

      if (result != null && result.files.isNotEmpty) {
        if (result.files.first.size > StaticData.maxFileSize) {
          throw SuccessFalse(StaticData.maxFilesSizeText);
        }
      }

      late File file;

      if (result != null) {
        file = File(result.files.first.path!);
      } else {
        unawaited(loadingState.accept(false));
        return;
      }

      final response = await AddPointsSaver.save(
        link,
        reviewLink,
        file,
      );

      message = response.message;

      if (addPointsModel.type == 'review_social') {
        unawaited(
          FirebaseAnalytics.instance.logEvent(name: 'soc_review_sended'),
        );
      }

      if (addPointsModel.type == 'review') {
        unawaited(FirebaseAnalytics.instance.logEvent(name: 'review_sended'));
      }

      final userRepository = await UserWriter.checkUserToken();
      if (userRepository == null) return;

      await userWm.userData.content(userRepository);
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
        title: e.toString(),
        ex: e,
      );
    }

    unawaited(loadingState.accept(false));

    if (error != null) {
      showDefaultNotification(
        title: error.title,
        subtitle: error.subtitle,
      );
    } else {
      // await Keys.bottomNav.currentState!.pushNamedAndRemoveUntil(
      //   '/final_addpoints',
      //   (route) => route.isCurrent,
      //   arguments: FinalAddPointsArguments(
      //     points: addPointsModel.reward,
      //     message: message,
      //   ),
      // );
      Keys.mainContentNav.currentState!.pop();
      showDefaultNotification(
        title: 'Ваш отзыв сохранен. Баллы будут начислены после модерации',
        success: true,
        duration: const Duration(seconds: 5),
      );
    }
  }
}

class AddPointsSaver {
  static Future<BaseResponseRepository> save(
    String link,
    String reviewLink,
    File file,
  ) async {
    final rh = RequestHandler();

    var _reviewLink = reviewLink;

    //* Убираю https
    if (reviewLink.startsWith('https://')) {
      _reviewLink = reviewLink.replaceAll('https://', '');
    } else if (reviewLink.startsWith('http://')) {
      _reviewLink = reviewLink.replaceAll('http://', '');
    }

    debugPrint(_reviewLink);

    final resp = await rh.post<Map<String, dynamic>>(
      link,
      data: FormData.fromMap(
        <String, dynamic>{
          'reviewScreenshot': await MultipartFile.fromFile(file.path),
          'link': _reviewLink,
        },
      ),
    );

    return BaseResponseRepository.fromMap(resp.data!);
  }

  static Future<void> beforeLaunchVKUrl() async {
    final rh = RequestHandler();

    await rh.post<Map<String, dynamic>>(
      '/user/vk/',
    );
  }
}
