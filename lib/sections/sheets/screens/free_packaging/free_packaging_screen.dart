import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/order_registration/order_registration_screen.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

//catalog_free_packaging
class FreePackagingScreen extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const FreePackagingScreen({
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
                    TopSection.packaging(model, key),
                    const SizedBox(
                      height: 4,
                    ),
                    InfoSection(),
                    const SizedBox(
                      height: 12,
                    ),
                    const LegalInfo(),
                    const SizedBox(
                      height: 160,
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
                text: 'Перейти к заказу',
                onPressed: () {
                  // Keys.mainNav.currentState!.pop();

                  // Keys.mainContentNav.currentState!
                  //     .pushNamed('/order_registration');

                  Keys.mainNav.currentState!.push<void>(
                    MaterialPageRoute(
                      builder: (context) {
                        return OrderRegistrationScreen();
                      },
                    ),
                  );
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
