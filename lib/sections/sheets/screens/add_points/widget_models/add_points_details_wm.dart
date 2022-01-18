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
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class AddPointsDetailsWM extends WidgetModel {
  final BuildContext context;
  final AddPointsModel addPointsModel;

  final loadingState = StreamedState<bool>(false);

  final buttonAction = VoidAction();

  late UserWM userWm;

  AddPointsDetailsWM({
    required this.context,
    required this.addPointsModel,
  }) : super(const WidgetModelDependencies());

  @override
  void onBind() {
    buttonAction.bind((_) {
      _btnAction();
    });
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
        await _addPoints('/review/save/');
        break;
      case 'review_social':
        await _addPoints('/review/soc/save/');
        break;
      case 'vk':
        await _launchVKUrl(addPointsModel.url);
        break;
      case 'invite_friend':
        await Utils.tryShare(text: addPointsModel.url);
        break;
    }
  }

  Future<void> _launchVKUrl(String? url) async {
    unawaited(loadingState.accept(true));

    CustomException? error;


    try {
      await AddPointsSaver.beforeLaunchVKUrl();
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
        isPhone: false,
      );
    }
  }

  Future<void> _addPoints(String link) async {
    unawaited(loadingState.accept(true));

    CustomException? error;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      late File file;

      if (result != null) {
        file = File(result.files.first.path!);
      } else {
        unawaited(loadingState.accept(false));
        return;
      }

      await AddPointsSaver.save(
        link,
        file,
      );

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
      await Keys.bottomNav.currentState!.pushNamedAndRemoveUntil(
        '/final_addpoints',
        (route) => route.isCurrent,
        arguments: FinalAddPointsArguments(
          points: addPointsModel.reward,
        ),
      );
    }
  }
}

class AddPointsSaver {
  static Future<BaseResponseRepository> save(
    String link,
    File file,
  ) async {
    final rh = RequestHandler();
    final resp = await rh.post<Map<String, dynamic>>(
      link,
      data: FormData.fromMap(
        <String, dynamic>{
          'reviewScreenshot': await MultipartFile.fromFile(file.path),
        },
      ),
      options: rh.cacheOptions
          ?.copyWith(
            maxStale: const Duration(days: 1),
            policy: CachePolicy.request,
          )
          .toOptions(),
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
