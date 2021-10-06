import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/models/sheet_model.dart';
import 'package:bausch/sections/sheets/product_sheet/product_sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/test/models.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';
import 'package:bausch/static/static_data.dart';

class FinalScreen extends StatelessWidget {
  final ScrollController controller;
  final CatalogItemModel model;
  const FinalScreen({required this.model, required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.sulu,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: Colors.white,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.close,
                              color: AppTheme.mineShaft,
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Подтвердите покупку',
                    style: AppStyles.h2,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'После подтверждения мы спишем баллы, и вы получите промокод',
                    style: AppStyles.p1,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            BlueButtonWithText(text: 'Потратить баллы'),
            InfoBlock(),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
