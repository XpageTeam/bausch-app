// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:bausch/models/sheets/folder/sheet_with_items_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';

//* Главный экран с элементами каталога
//* С него происходит переход в нужные секции
class SheetScreen extends StatelessWidget {
  final ScrollController controller;

  final SheetModelWithItems sheetModel;

  final String path;
  const SheetScreen({
    required this.sheetModel,
    required this.controller,
    required this.path,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        body: CustomScrollView(
          controller: controller,
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
                          sheetModel.img ?? 'assets/free-packaging.png',
                          height: 60,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            sheetModel.title,
                            style: AppStyles.h2,
                          ),
                        ),
                      ],
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
                        CatalogItem(
                          //context,
                          model: sheetModel.models![i * 2],
                          isProduct:
                              sheetModel.type != SheetWithItemsType.webinar
                                  ? true
                                  : false,
                          onTap: () {
                            Keys.bottomSheetItemsNav.currentState!
                                .pushNamed(path);
                          },
                        ),
                        if (sheetModel.models!.asMap().containsKey(i * 2 + 1))
                          CatalogItem(
                            //context,
                            model: sheetModel.models![i * 2 + 1],
                            isProduct:
                                sheetModel.type != SheetWithItemsType.webinar
                                    ? true
                                    : false,
                            onTap: () {
                              Keys.bottomSheetItemsNav.currentState!
                                  .pushNamed(path);
                            },
                          ),
                      ],
                    ),
                  ),
                  childCount: (sheetModel.models!.length % 2) == 0
                      ? sheetModel.models!.length ~/ 2
                      : sheetModel.models!.length ~/ 2 + 1,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 60,
                    child: Text(
                      'Имеются противопоказания, необходимо проконсультироваться со специалистом',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 16 / 14,
                        color: AppTheme.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
