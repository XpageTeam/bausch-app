// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/may_be_interesting_item.dart';
import 'package:bausch/models/sheets/catalog_sheet_without_logos_model.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class MayBeInterestingWM extends WidgetModel {
  final BuildContext context;

  final catalogItems = EntityStreamedState<List<CatalogItemModel>>();
  final loadingState = StreamedState<bool>(false);

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
      final repository = await InterestingProductsDownloader.load();

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
    // unawaited(loadingState.accept(true));
    showLoader(context);

    CatalogItemModel? itemModel;
    CustomException? ex;

    try {
      itemModel = await ProductsDownloader.getProductById(
        model!.id,
        type: model.type!,
      );
    } on DioError catch (e) {
      ex = CustomException(
        title: 'При отправке запроса произошла ошибка',
        subtitle: e.message,
        ex: e,
      );
    } on ResponseParseException catch (e) {
      ex = CustomException(
        title: 'При чтении ответа от сервера произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
    } on SuccessFalse catch (e) {
      ex = CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
        ex: e,
      );
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      ex = CustomException(
        title: 'Произошла ошибка',
        subtitle: e.toString(),
      );
    }

    Keys.mainNav.currentState!.pop();

    if (ex != null) {
      showTopError(ex);
      if (Keys.mainContentNav.currentState!.canPop()) {
        Keys.mainContentNav.currentState!.pop();
      }
      return;
    }

    if (itemModel != null) {
      _showBottomSheet(itemModel, model!.type!);
    }
  }

  void _showBottomSheet(CatalogItemModel model, String section) {
    if (section == 'online_consultation') {
      showSheet<List<CatalogItemModel>>(
        context,
        CatalogSheetWithoutLogosModel(
          id: 0,
          name: 'online_consultation',
          type: section,
          icon: model.picture!,
          count: 1,
        ),
        [model],
      );
    } else {
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
}
