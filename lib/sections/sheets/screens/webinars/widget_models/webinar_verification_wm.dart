import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class WebinarVerificationWM extends WidgetModel {
  final BuildContext context;
  final CatalogItemModel itemModel;

  final loadingState = StreamedState<bool>(false);
  final spendPointsAction = VoidAction();

  late int points;
  late int remains;

  late UserWM userWm;

  WebinarVerificationWM({
    required this.context,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    userWm = Provider.of<UserWM>(
      context,
      listen: false,
    );
    points = userWm.userData.value.data?.balance.available.toInt() ?? 0;

    remains = points - itemModel.price;

    super.onLoad();
  }

  @override
  void onBind() {
    spendPointsAction.bind(
      (_) => _spendPoints(),
    );

    super.onBind();
  }

  Future<void> _spendPoints() async {
    unawaited(loadingState.accept(true));

    CustomException? error;
    String? videoId;

    try {
      final repository = await OrderWebinarSaver.save(
        itemModel,
      );

      videoId = repository.videoIds.first;

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
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    }

    unawaited(loadingState.accept(false));

    if (error != null) {
      _showTopError(error);
    } else {
      await Keys.bottomSheetItemsNav.currentState!.pushNamed(
        '/final_webinar',
        arguments: FinalWebinarArguments(
          model: itemModel,
          videoId: videoId!,
        ),

        //  SheetScreenArguments(model: itemModel),
      );
    }
  }

  void _showTopError(CustomException ex) {
    showDefaultNotification(
      title: ex.title,
      subtitle: ex.subtitle,
    );
  }
}

class FinalWebinarArguments extends SheetScreenArguments {
  final String videoId;
  FinalWebinarArguments({
    required CatalogItemModel model,
    required this.videoId,
  }) : super(model: model);
}

class OrderWebinarSaver {
  static Future<WebinarsRepository> save(CatalogItemModel model) async {
    final rh = RequestHandler();
    final response =
        BaseResponseRepository.fromMap((await rh.put<Map<String, dynamic>>(
      '/order/webinar/',
      data: FormData.fromMap(
        <String, dynamic>{
          'productId': model.id,
          // TODO(Nikolay): Изменить цену.
          'price': 1,
        },
      ),
      options: rh.cacheOptions
          ?.copyWith(
            maxStale: const Duration(days: 1),
            policy: CachePolicy.request,
          )
          .toOptions(),
    ))
            .data!);

    return WebinarsRepository.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}

class WebinarsRepository {
  final List<String> videoIds;

  WebinarsRepository(this.videoIds);

  factory WebinarsRepository.fromJson(Map<String, dynamic> json) =>
      WebinarsRepository(
        (json['videoIds'] as List<dynamic>)
            .map((dynamic e) => e as String)
            .toList(),
      );
}