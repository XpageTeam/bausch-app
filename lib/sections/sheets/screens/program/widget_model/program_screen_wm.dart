// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/program/primary_data.dart';
import 'package:bausch/models/program/primary_data_downloader.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
  final whatDoYouUse = StreamedState<String>('');
  final whatDoYouUseIndex = StreamedState<int>(0);

  final loadingStreamed = StreamedState<bool>(false);
  final getCertificateAction = VoidAction();

  final colorState = StreamedState<Color>(Colors.white);

  String city = '';

  List<OpticCity> cities = [];

  String get fullAddress {
    final optic = currentOpticStreamed.value;
    return '${optic!.title}, г. $city, ${optic.shops.first.address}';
  }

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
    selectOptic.bind((optic) {
      AppsflyerSingleton.sdk
          .logEvent('programmOpticSelected', <String, dynamic>{
        'id': optic?.id,
        'title': optic?.title,
        'shopCode': optic?.shopCode,
      });

      currentOpticStreamed.accept(optic);
    });
    getCertificateAction.bind((_) => _getCertificate());

    super.onBind();
  }

  Future<void> _getCertificate() async {
    unawaited(loadingStreamed.accept(true));
    CustomException? ex;

    ProgramSaverResponse? response;
    try {
      response = await ProgramSertificatSaver.save(
        name: firstNameController.text,
        opticName: currentOpticStreamed.value?.shops.first.title ?? 'null',
        opticAddress:
            '$city, ${currentOpticStreamed.value!.shops.first.address}',
        whatDoYouUse: whatDoYouUse.value,
        opticEmail: currentOpticStreamed.value?.shops.first.email ?? 'null',
        opticManager: currentOpticStreamed.value?.shops.first.manager ?? 'null',
        opticPhone:
            (currentOpticStreamed.value?.shops.first.phones.isNotEmpty) ?? false
                ? currentOpticStreamed.value!.shops.first.phones.first
                : '',
      );

      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'certificate_registration',
          parameters: <String, dynamic>{
            'whatDoYouUse': whatDoYouUse.value,
            'name': firstNameController.text,
            'opticName':
                currentOpticStreamed.value?.shops.first.title ?? 'null',
            'opticAddress':
                '$city, ${currentOpticStreamed.value!.shops.first.address}',
            'opticPhone':
                (currentOpticStreamed.value?.shops.first.phones.isNotEmpty) ??
                        false
                    ? currentOpticStreamed.value!.shops.first.phones.first
                    : '',
            'opticEmail':
                currentOpticStreamed.value?.shops.first.email ?? 'null',
            'opticManager':
                currentOpticStreamed.value?.shops.first.manager ?? 'null',
          },
        ),
      );

      await Keys.bottomNav.currentState!.pushNamedAndRemoveUntil(
        '/final_program',
        (route) => route.isCurrent,
        arguments: <String, dynamic>{
          'optic': currentOpticStreamed.value,
          'response': response,
        },
      );
    } on DioError catch (e) {
      ex = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
      );
    } on ResponseParseException catch (e) {
      ex = CustomException(
        title: 'Не удалось обработать ответ от сервера',
        subtitle: e.toString(),
      );
    } on SuccessFalse catch (e) {
      ex = CustomException(
        title: e.toString(),
      );
    }

    unawaited(loadingStreamed.accept(false));

    if (ex != null) {
      showTopError(ex);
    }
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

      unawaited(whatDoYouUse
          .accept(primaryDataStreamed.value.data!.whatDoYouUse.first));
    } on DioError catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'При отправке запроса произошла ошибка',
            subtitle: e.message,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: 'Не удалось обработать ответ от сервера',
            subtitle: e.toString(),
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        primaryDataStreamed.error(
          CustomException(
            title: e.toString(),
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
    try {
      return ProgramSaverResponse(
        title: map['title'] as String,
        promocode: map['promocode'] as String,
        subtitle: map['subtitle'] as String,
      );
    } catch (e) {
      throw ResponseParseException('ProgramSaverResponse: $e');
    }
  }
}

class ProgramSertificatSaver {
  static Future<ProgramSaverResponse> save({
    required String name,
    required String opticAddress,
    required String opticName,
    required String opticManager,
    required String opticPhone,
    required String opticEmail,
    String? whatDoYouUse,
  }) async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.post<Map<String, dynamic>>(
        '/selection/save/',
        data: FormData.fromMap(<String, dynamic>{
          'whatDoYouUse': whatDoYouUse,
          'name': name,
          'opticName': opticName,
          'opticAddress': opticAddress,
          'opticPhone': opticPhone,
          'opticEmail': opticEmail,
          'opticManager': opticManager,
        }),
      ))
          .data!,
    );
    final response =
        ProgramSaverResponse.fromJson(res.data as Map<String, dynamic>);
    return response;
  }
}
