import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/may_be_interesting_item.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class MayBeInterestingWM extends WidgetModel {
  final BuildContext context;

  final catalogItems = EntityStreamedState<List<CatalogItemModel>>();

  final onTapAction = StreamedAction<CatalogItemModel>();

  MayBeInterestingWM({
    required this.context,
  }) : super(
          const WidgetModelDependencies(),
        );
  @override
  void onLoad() {
    _loadCatalogItems();
    super.onLoad();
  }

  @override
  void onBind() {
    onTapAction.bind(_onTap);
    super.onBind();
  }

  Future<void> _loadCatalogItems() async {
    try {
      final repository = await MayBeInterestingItemsDownloader.load();

      unawaited(
        catalogItems.content(repository.items),
      );
    } on DioError catch (e) {
      CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    }
  }

  Future<void> _onTap(CatalogItemModel? model) async {
    CatalogItemModel? itemModel;

    try {
      final repository = await ProductsDownloader.load(model!.type!);
      itemModel =
          repository.items.firstWhere((element) => element.id == model.id);
    } on DioError catch (e) {
      CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    }
    if (itemModel != null) {
      _showBottomSheet(itemModel, model!.type!);
    }
  }

  void _showBottomSheet(CatalogItemModel model, String section) {
    showSheet<ItemSheetScreenArguments>(
      context,
      SimpleSheetModel(
        name: 'Title',
        type: section,
      ),
      ItemSheetScreenArguments(model: model),
      '/$section',
    );
  }
}
