// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';

class SheetScreenArguments {
  final CatalogItemModel model;

  SheetScreenArguments({required this.model});
}

//* Главный экран с элементами каталога
//* С него происходит переход в нужные секции
class SheetScreen extends StatefulWidget {
  final ScrollController controller;

  final BaseCatalogSheetModel sheetModel;

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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        body: CustomScrollView(
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
                            style: AppStyles.h2,
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
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CatalogItem(
                            model: widget.items[i * 2],
                            onTap: () {
                              Keys.bottomSheetItemsNav.currentState!.pushNamed(
                                '/${widget.sheetModel.type}',
                                arguments: SheetScreenArguments(
                                  model: widget.items[i * 2],
                                ),
                              );
                            },
                          ),
                          if (widget.items.asMap().containsKey(i * 2 + 1))
                            CatalogItem(
                              model: widget.items[i * 2 + 1],
                              onTap: () {
                                Keys.bottomSheetItemsNav.currentState!
                                    .pushNamed(
                                  '/${widget.sheetModel.type}',
                                  arguments: SheetScreenArguments(
                                    model: widget.items[i * 2 + 1],
                                  ),
                                );
                              },
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
            // SliverList(
            //   delegate: SliverChildListDelegate(
            //     [
            //       const SizedBox(
            //         height: 60,
            //         child: Text(
            //           'Имеются противопоказания, необходимо проконсультироваться со специалистом',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontWeight: FontWeight.w400,
            //             fontSize: 14,
            //             height: 16 / 14,
            //             color: AppTheme.grey,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: const [
            InfoBlock(),
          ],
        ),
        // bottomSheet: const SizedBox(
        //   height: 60,
        //   child: InfoBlock(),
        // ),
      ),
    );
  }
}
