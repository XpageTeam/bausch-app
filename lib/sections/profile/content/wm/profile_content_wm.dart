import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/sections/profile/content/downloader/downloader.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:dio/dio.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileContentWM extends WidgetModel {
  final allDataLoadingState = EntityStreamedState<bool>();

  final orderHistoryList = EntityStreamedState<List<BaseOrderModel?>>();

  final loadOrdersHistoryAction = VoidAction();
  final allDataLoadAction = VoidAction();

  final _downloader = ProfileContentDownloader();

  ProfileContentWM() : super(const WidgetModelDependencies());

  @override
  void onLoad() {
    loadOrdersHistoryAction.bind((_) {
      _loadOrdersHistory();
    });

    allDataLoadAction.bind((_) {
      _loadAllData();
    });

    


    allDataLoadAction();

    super.onLoad();
  }

  Future<void> _loadAllData() async {
    if (allDataLoadingState.value.isLoading) return;

    unawaited(allDataLoadingState.loading());

    await Future.wait<void>([
      _loadOrdersHistory(),
    ]);
    
    if (orderHistoryList.value.hasError){
      await allDataLoadingState.error(orderHistoryList.value.error);
      return;
    }

    await allDataLoadingState.content(true);
  }

  Future<void> _loadOrdersHistory() async {
    if (orderHistoryList.value.isLoading) return;

    unawaited(orderHistoryList.loading());

    try {
      await orderHistoryList.content(await _downloader.loadOrderHistory());
    } on DioError catch (e) {
      await orderHistoryList.error(CustomException(
        title: 'При загрузке истории заказов произошла ошибка',
        subtitle: e.message,
        ex: e,
      ));
    } on ResponseParseException catch (e){
      await orderHistoryList.error(CustomException(
        title: 'При обработке ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      ));
    } on SuccessFalse catch (e){
      await orderHistoryList.error(CustomException(
        title: e.toString(),
        ex: e,
      ));
    }
  }
}
