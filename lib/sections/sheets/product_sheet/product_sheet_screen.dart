import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/how_to_use_promocode.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/select_shop.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductSheetArguments {
  final CatalogItemModel model;
  final SheetType type;

  ProductSheetArguments(this.model, this.type);
}

class ProductSheet extends StatelessWidget implements ProductSheetArguments {
  final ScrollController controller;
  @override
  final CatalogItemModel model;
  @override
  final SheetType type;

  const ProductSheet(
      {required this.controller,
      required this.model,
      required this.type,
      Key? key})
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
                    TopSection(
                      model: model,
                      type: type,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const InfoSection(),
                    const SizedBox(
                      height: 12,
                    ),
                    if (type == SheetType.packaging) const LegalInfo(),
                    const SizedBox(
                      height: 120,
                    ),
                    if (type == SheetType.discountOptics)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Выбрать сеть оптик',
                            style: AppStyles.h2,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Скидкой можно воспользоваться в любой из оптик сети.',
                            style: AppStyles.p1,
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
            if (type == SheetType.discountOptics)
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                sliver: SelectShopSection(),
              ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    if (type == SheetType.discountOptics) Warning(),
                    const SizedBox(
                      height: 40,
                    ),
                    if (type == SheetType.discountOptics) HowToUsePromocode(),
                    const SizedBox(
                      height: 40,
                    ),
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
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding),
              child: BlueButtonWithText(
                text: 'Перейти к заказу',
                onPressed: () {
                  Utils.bottomSheetNav.currentState!.pushNamed('/verification');
                },
              ),
            ),
            InfoBlock(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
