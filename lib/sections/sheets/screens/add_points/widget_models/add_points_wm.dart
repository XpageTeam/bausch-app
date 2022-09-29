import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/add_points/add_points_model.dart';
import 'package:bausch/sections/sheets/screens/add_points/requester/add_points_requester.dart';
import 'package:bausch/widgets/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class AddPointsWM extends WidgetModel {
  final addPointsList = EntityStreamedState<List<AddPointsModel>>()..content([]);

  final loadInfoAction = VoidAction();

  final BuildContext context;

  final _requester = AddPointsRequester();

  AddPointsWM({
    required this.context,
  }) : super(const WidgetModelDependencies());

  @override
  void onBind() {
    loadInfoAction.bind((_) {
      _loadInfo();
    });

    loadInfoAction();
    super.onBind();
  }

  /// Загружает дополнительные способы добавления баллов
  ///! не использовать [addPointsList].error
  Future<void> _loadInfo() async {
    if (addPointsList.value.isLoading) return;

    await addPointsList.loading(addPointsList.value.data);

    CustomException? error;

    try {
      await addPointsList.content(await _requester.loadAddMore());
    } on DioError catch (e) {
      error = CustomException(
        title: 'При загрузке способов добавления баллов произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      error = CustomException(
        title: 'При обработке ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      error = CustomException(title: e.toString());
    }

    if (error != null) {
      showDefaultNotification(
        title: error.title,
        subtitle: error.subtitle,
      );

      await addPointsList.content([]);
    }
  }
}
