import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

//catalog_partners
class PartnersScreen extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const PartnersScreen({
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
                    TopSection.partners(model, Container(), key),
                    const SizedBox(
                      height: 4,
                    ),
                    InfoSection(),
                    const SizedBox(
                      height: 4,
                    ),
                    Warning.advertisment(),
                    const SizedBox(
                      height: 120,
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
                text: 'Получить поощрение',
                onPressed: () {
                  Keys.bottomSheetItemsNav.currentState!
                      .pushNamed('/verification_webinar');
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
