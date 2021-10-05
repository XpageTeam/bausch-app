import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/select_shop.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

class ProductSheetArguments {
  final CatalogItemModel model;

  ProductSheetArguments(this.model);
}

class ProductSheet extends StatelessWidget implements ProductSheetArguments {
  final ScrollController controller;
  @override
  final CatalogItemModel model;

  const ProductSheet({required this.controller, required this.model, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 12, left: 12, right: 12, bottom: 4),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    TopSection(model: model),
                    const SizedBox(
                      height: 4,
                    ),
                    const InfoSection(),
                    const SizedBox(
                      height: 12,
                    ),
                    const LegalInfo(),
                    const SizedBox(
                      height: 120,
                    ),
                    const Text(
                      'Выбрать интернет-магазин',
                      style: AppStyles.h2,
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              sliver: SelectShopSection(),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.sulu,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              'assets/substract.png',
                              height: 16,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Flexible(
                              child: Text(
                                'Перед тем как оформить заказ, узнайте о наличие продукта в интернет-магазине',
                                style: AppStyles.h3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 120,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            BlueButtonWithText(text: 'Перейти к заказу'),
            InfoBlock(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
