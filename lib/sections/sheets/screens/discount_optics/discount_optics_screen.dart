import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/select_shop.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/widgets/how_to_use_promocode.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:flutter/material.dart';

//catalog_discount_optics
class DiscountOpticsScreen extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const DiscountOpticsScreen({
    required this.controller,
    required this.model,
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
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 12,
                left: 12,
                right: 12,
                bottom: 4,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    TopSection.product(model, Container(), key),
                    const SizedBox(
                      height: 4,
                    ),
                    InfoSection.product(),
                    const SizedBox(
                      height: 12,
                    ),
                    const LegalInfo(),
                    const SizedBox(
                      height: 40,
                    ),
                    const Text(
                      'Выбрать сеть оптик',
                      style: AppStyles.h2,
                    ),
                    const Text(
                      'Скидкой можно воспользоваться в любой из оптик сети.',
                      style: AppStyles.p1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
              sliver: SelectShopSection(),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                        bottom: 10,
                      ),
                      child: WhiteButton(
                        text: 'Адреса оптик',
                        onPressed: () {},
                      ),
                    ),
                    Warning.warning(),
                    const Padding(
                      padding: EdgeInsets.only(top: 40, bottom: 160),
                      child: HowToUsePromocode(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: BlueButtonWithText(
                text: 'Получить скидку',
                onPressed: () {
                  Keys.bottomSheetNav.currentState!
                      .pushNamed('/verification_discount');
                },
              ),
            ),
            const InfoBlock(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}