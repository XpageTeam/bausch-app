// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/models/orders_data/order_data.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';

class ItemSheetScreenArguments {
  final CatalogItemModel model;
  final OrderData? orderData;
  final String? discount;
  final String section;

  ItemSheetScreenArguments({
    required this.model,
    this.section = '',
    this.orderData,
    this.discount,
  });
}

class SheetScreenArguments {
  final BaseCatalogSheetModel sheetModel;
  final List<CatalogItemModel> items;

  SheetScreenArguments({
    required this.sheetModel,
    required this.items,
  });
}

//* Главный экран с элементами каталога
//* С него происходит переход в нужные секции
class SheetScreen extends StatefulWidget implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final BaseCatalogSheetModel sheetModel;

  @override
  final List<CatalogItemModel> items;

  //final String path;
  const SheetScreen({
    required this.sheetModel,
    required this.controller,
    required this.items,

    // required this.path,
    Key? key,
  }) : super(key: key);

  @override
  State<SheetScreen> createState() => _SheetScreenState();
}

class _SheetScreenState extends State<SheetScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    AppsflyerSingleton.sdk.logEvent('catalogOpened', <String, dynamic>{
      'id': widget.sheetModel.id,
      'type': widget.sheetModel.type,
      'name': widget.sheetModel.name,
    });

    AppMetrica.reportEventWithMap('catalogOpened', <String, Object>{
      'id': widget.sheetModel.id,
      'type': widget.sheetModel.type,
      'name': widget.sheetModel.name,
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      slivers: [
        if (widget.items.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'Пусто',
                style: AppStyles.h2,
              ),
            ),
          ),
        if (widget.items.isNotEmpty) ...[
          SliverAppBar(
            pinned: true,
            elevation: 0,
            toolbarHeight: 70, //widget.sheetModel.icon != null ? 100 : 65,
            backgroundColor: AppTheme.mystic,
            flexibleSpace: Container(
              color: AppTheme.mystic,
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                20,
                StaticData.sidePadding,
                20,
              ),
              child: Row(
                children: [
                  if (widget.sheetModel.icon != null)
                    Image.network(
                      widget.sheetModel.icon!,
                      height: 60,
                    ),
                  if (widget.sheetModel.icon != null)
                    const SizedBox(
                      width: 10,
                    ),
                  Flexible(
                    child: Text(
                      widget.sheetModel.name,
                      style: AppStyles.h1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 40,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, i) => IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          CatalogItem(
                            model: widget.items[i * 2],
                            onTap: () {
                              _openItemSheet(
                                widget.items[i * 2],
                              );
                            },
                            allWebinarsCallback: _openAllWebinars,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: widget.items[i * 2].fetchShield(
                              discountCount: widget.sheetModel.discount == null
                                  ? null
                                  : '${widget.sheetModel.discount}',
                            ),
                          ),
                        ],
                      ),
                      if (widget.items.asMap().containsKey(i * 2 + 1))
                        Stack(
                          children: [
                            CatalogItem(
                              model: widget.items[i * 2 + 1],
                              onTap: () {
                                _openItemSheet(
                                  widget.items[i * 2 + 1],
                                  discount: widget.sheetModel.discount,
                                );
                              },
                              allWebinarsCallback: _openAllWebinars,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: widget.items[i * 2 + 1].fetchShield(
                                discountCount:
                                    widget.sheetModel.discount == null
                                        ? null
                                        : '${widget.sheetModel.discount}',
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                childCount: (widget.items.length % 2) == 0
                    ? widget.items.length ~/ 2
                    : widget.items.length ~/ 2 + 1,
              ),
            ),
          ),
        ],
      ],
      bottomNavBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.sheetModel.type != 'promo_code_immediately')
            const BottomInfoBlock(),
        ],
      ),
    );
  }

  void _openItemSheet(
    CatalogItemModel model, {
    String? discount,
  }) {
    final originType = widget.sheetModel.type;

    var type = originType;

    if (type.contains('online') || type.contains('offline')) {
      type = type.contains('online') ? 'onlineShop' : 'offline';
    }

    Navigator.of(context).pushNamed(
      '/$type',
      arguments: ItemSheetScreenArguments(
        model: model,
        discount: discount,
        section: originType,
      ),
    );
  }

  void _openAllWebinars(WebinarItemModel webinar) {
    // ignore: unused_local_variable
    final webinars = widget.items
        .where((e) => (e as WebinarItemModel).videoIds.length == 1)
        .toList();

    Navigator.of(context).pushNamed(
      '/all_webinars',
      arguments: ItemSheetScreenArguments(
        model: webinar,
      ),
    );
  }
}
