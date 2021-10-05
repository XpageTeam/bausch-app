import 'package:bausch/models/sheet_model.dart';
import 'package:bausch/sections/sheets/product_sheet/product_sheet_screen.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:bausch/static/static_data.dart';

class Sheet extends StatelessWidget {
  final ScrollController controller;
  final SheetModel model;
  const Sheet({required this.model, required this.controller, Key? key})
      : super(key: key);

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
                          model.img ?? 'assets/free-packaging.png',
                          height: 60,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            model.title,
                            style: AppStyles.h2,
                          ),
                        ),
                      ],
                    )
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
                          model: model.models[i * 2],
                        ),
                        if (model.models.asMap().containsKey(i * 2 + 1))
                          CatalogItem(model: model.models[i * 2 + 1])
                      ],
                    ),
                  ),
                  childCount: (model.models.length % 2) == 0
                      ? model.models.length ~/ 2
                      : model.models.length ~/ 2 + 1,
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildListDelegate([
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
              )
            ])),
          ],
        ),
      ),
    );
  }
}
