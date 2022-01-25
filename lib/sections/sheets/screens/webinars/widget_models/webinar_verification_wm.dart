import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/repositories/user/user_writer.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class WebinarVerificationWM extends WidgetModel {
  final BuildContext context;
  final WebinarItemModel itemModel;

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
    //String? videoId;

    try {
      // ignore: unused_local_variable
      final repository = await OrderWebinarSaver.save(
        itemModel,
      );

      //videoId = repository.videoIds.first;

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
      showTopError(error);
    } else {
      await Keys.bottomNav.currentState!.pushNamedAndRemoveUntil(
        '/final_webinar',
        (route) => route.isCurrent,
        arguments: FinalWebinarArguments(
          model: itemModel,
          videoIds: itemModel.videoIds,
        ),

        //  SheetScreenArguments(model: itemModel),
      );
    }
  }
}

class FinalWebinarArguments extends ItemSheetScreenArguments {
  final List<String> videoIds;
  FinalWebinarArguments({
    required CatalogItemModel model,
    required this.videoIds,
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
          'price': model.price,
        },
      ),
    ))
            .data!);

    return WebinarsRepository.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}

// class WebinarsRepository {
//   final List<String> videoIds;

//   WebinarsRepository(this.videoIds);

//   factory WebinarsRepository.fromJson(Map<String, dynamic> json) =>
//       WebinarsRepository(
//         (json['videoIds'] as List<dynamic>)
//             // ignore: avoid_annotating_with_dynamic
//             .map((dynamic e) => e as String)
//             .toList(),
//       );
// }

class WebinarsRepository {
  final int orderId;
  final String title;
  final String subtitle;

  WebinarsRepository({
    required this.orderId,
    required this.title,
    required this.subtitle,
  });

  factory WebinarsRepository.fromJson(Map<String, dynamic> map) {
    return WebinarsRepository(
      orderId: map['orderId'] as int,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
    );
  }
}
