// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/sections/sheets/screens/webinars/all_webinars_screen.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';

class ItemSheetScreenArguments {
  final CatalogItemModel model;

  ItemSheetScreenArguments({required this.model});
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 20,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  children: [
                    Image.asset(
                      setTheImg(widget.sheetModel.type),
                      height: 60,
                    ),
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
              ],
            ),
          ),
        ),
        if (widget.items.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text(
                'Пусто',
                style: AppStyles.h2,
              ),
            ),
          ),
        if (widget.items.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              bottom: 40,
            ),
            // TODO(Nikita): очень громоздко
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
                              Navigator.of(context).pushNamed(
                                '/${widget.sheetModel.type}',
                                arguments: ItemSheetScreenArguments(
                                  model: widget.items[i * 2],
                                ),
                              );
                            },
                            allWebinarsCallback: _openAllWebinars,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: widget.items[i * 2].shield,
                          ),
                        ],
                      ),
                      if (widget.items.asMap().containsKey(i * 2 + 1))
                        Stack(
                          children: [
                            CatalogItem(
                              model: widget.items[i * 2 + 1],
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/${widget.sheetModel.type}',
                                  arguments: ItemSheetScreenArguments(
                                    model: widget.items[i * 2 + 1],
                                  ),
                                );
                              },
                              allWebinarsCallback: _openAllWebinars,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: widget.items[i * 2 + 1].shield,
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
        SliverToBoxAdapter(
          child: TextButton(
            child: const Text('Go'),
            onPressed: () => Navigator.of(context).pushNamed(
              '/all_webinars',
              arguments: AllWebinarsScreenArguments(
                // TODO(Nikolay): Переделать.
                model: widget.items.last,
                webinars: widget.items.take(widget.items.length - 1).toList(),
              ),
            ),
          ),
        ),
      ],
      bottomNavBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.sheetModel.type != 'promo_code_immediately')
            const InfoBlock(),
        ],
      ),
    );
  }

  void _openAllWebinars(WebinarItemModel webinar) {
    final webinars = widget.items
        .where((e) => (e as WebinarItemModel).videoIds.length == 1)
        .toList();

    Navigator.of(context).pushNamed(
      '/all_webinars',
      arguments: AllWebinarsScreenArguments(
        model: webinar,
        webinars: webinars,
      ),
    );
  }
}
