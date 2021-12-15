import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class DiscountOpticsScreenWM extends WidgetModel {
  final BuildContext context;
  final PromoItemModel itemModel;

  final discountOpticsStreamed = EntityStreamedState<List<DiscountOptic>>();
  final currentDiscountOptic = StreamedState<DiscountOptic?>(null);
  final setCurrentOptic = StreamedAction<DiscountOptic>();

  final buttonAction = VoidAction();

  late int difference;

  DiscountOpticsScreenWM({
    required this.context,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        ) {
    _loadDiscountOptics();
  }

  @override
  void onLoad() {
    final points = Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data?.balance.available.toInt() ??
        0;
    difference = itemModel.price - points;
  }

  @override
  void onBind() {
    setCurrentOptic.bind(
      currentDiscountOptic.accept,
    );

    buttonAction.bind(
      (_) {
        if (difference > 0) {
          Keys.bottomSheetItemsNav.currentState!.pushNamed(
            '/add_points',
          );
        } else {
          Keys.bottomSheetItemsNav.currentState!.pushNamed(
            '/verification_discount_optics',
            arguments: VerificationDiscountArguments(
              model: itemModel,
              discountOptic: currentDiscountOptic.value!,
            ),
          );
        }
      },
    );
    super.onBind();
  }

  Future<void> _loadDiscountOptics() async {
    unawaited(discountOpticsStreamed.loading());

    try {
      final repository = await DiscountOpticsLoader.load(
        'offline',
        itemModel.code,
      );
      unawaited(discountOpticsStreamed.content(repository.discountOptics));
    } on DioError catch (e) {
      unawaited(
        discountOpticsStreamed.error(
          CustomException(
            title: 'При отправке запроса произошла ошибка',
            subtitle: e.message,
          ),
        ),
      );
    } on ResponseParseException catch (e) {
      unawaited(
        discountOpticsStreamed.error(
          CustomException(
            title: 'При чтении ответа от сервера произошла ошибка',
            subtitle: e.toString(),
          ),
        ),
      );
    } on SuccessFalse catch (e) {
      unawaited(
        discountOpticsStreamed.error(
          CustomException(
            title: 'Произошла ошибка',
            subtitle: e.toString(),
          ),
        ),
      );
    }
  }
}

class DiscountOpticsLoader {
  static Future<DiscountOpticsRepository> load(
    String category,
    String productCode,
  ) async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        '/order/available-optics/',
        queryParameters: <String, dynamic>{
          'category': 'offline',
          'productCode': productCode,
        },
        options: rh.cacheOptions
            ?.copyWith(
              maxStale: const Duration(days: 2),
              policy: CachePolicy.request,
            )
            .toOptions(),
      ))
          .data!,
    );

    return DiscountOpticsRepository.fromList(res.data as List<dynamic>);
  }
}
