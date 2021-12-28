import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/program/primary_data.dart';
import 'package:bausch/models/program/primary_data_downloader.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProgramScreenWM extends WidgetModel {
  final BuildContext context;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  final primaryDataStreamed = EntityStreamedState<PrimaryData>();

  final selectOptic = StreamedAction<Optic>();

  final currentOpticStreamed = StreamedState<Optic?>(null);

  final loadingStreamed = StreamedState<bool>(false);
  final getSertificatAction = VoidAction();

  ProgramScreenWM({
    required this.context,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    _loadData();
    _initUserData();
    super.onLoad();
  }

  @override
  void onBind() {
    selectOptic.bind(currentOpticStreamed.accept);
    getSertificatAction.bind((_) => _getSertificat());

    super.onBind();
  }

  Future<void> _getSertificat() async {
    unawaited(loadingStreamed.accept(true));
    ProgramSaverResponse? response;
    try {
      response = await ProgramSertificatSaver.save();

      await Keys.bottomNav.currentState!.pushNamedAndRemoveUntil(
        '/final_program',
        (route) => route.isCurrent,
        arguments: <String, dynamic>{
          'optic': currentOpticStreamed.value,
          'response': response,
        },
      );
    } on DioError catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.message,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
    }
    unawaited(loadingStreamed.accept(false));
  }

  void _initUserData() {
    final user =
        Provider.of<UserWM>(context, listen: false).userData.value.data?.user;

    if (user == null) return;

    firstNameController.text = user.name ?? '';
    lastNameController.text = user.lastName ?? '';
    emailController.text = user.email ?? '';
  }

  Future<void> _loadData() async {
    unawaited(primaryDataStreamed.loading());

    try {
      final data = await PrimaryDataDownloader.load();

      unawaited(primaryDataStreamed.content(data));
    } on DioError catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.message,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Невозможно загрузить предложение',
            subtitle: e.toString(),
          ),
        ),
      );
    }
  }
}

class ProgramSaverResponse {
  final String title;
  final String promocode;
  final String subtitle;

  ProgramSaverResponse({
    required this.title,
    required this.promocode,
    required this.subtitle,
  });

  factory ProgramSaverResponse.fromJson(Map<String, dynamic> map) {
    if (map['title'] == null) {
      throw ResponseParseException('Неудалось получить сертификат');
    }
    if (map['promocode'] == null) {
      throw ResponseParseException('Неудалось получить сертификат');
    }
    if (map['subtitle'] == null) {
      throw ResponseParseException('Неудалось получить сертификат');
    }
    return ProgramSaverResponse(
      title: map['title'] as String,
      promocode: map['promocode'] as String,
      subtitle: map['subtitle'] as String,
    );
  }
}

class ProgramSertificatSaver {
  static Future<ProgramSaverResponse> save() async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.post<Map<String, dynamic>>(
        '/selection/save/',
        options: rh.cacheOptions
            ?.copyWith(
              maxStale: const Duration(days: 1),
              policy: CachePolicy.request,
            )
            .toOptions(),
      ))
          .data!,
    );
    final response =
        ProgramSaverResponse.fromJson(res.data as Map<String, dynamic>);
    return response;
  }
}
