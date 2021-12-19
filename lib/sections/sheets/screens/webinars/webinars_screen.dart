import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/material.dart';

//catalog_webinar
class WebinarsScreen extends StatelessWidget implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final WebinarItemModel model;

  const WebinarsScreen({
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
          physics: const BouncingScrollPhysics(),
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
                    TopSection.webinar(model, key),
                    const SizedBox(
                      height: 4,
                    ),
                    InfoSection(
                      text: model.previewText,
                      secondText: model.detailText,
                    ),
                    const SizedBox(
                      height: 132,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: CustomFloatingActionButton(
          text: 'Перейти к просмотру',
          onPressed: () {
            Keys.bottomSheetItemsNav.currentState!.pushNamed(
              '/verification_webinar',
              arguments: SheetScreenArguments(model: model),
            );
            // debugPrint(model.vimeoId);
            // showDialog<void>(
            //   context: Keys.bottomSheetItemsNav.currentContext!,
            //   builder: (context) {
            //     return DialogWithPlayers(
            //       vimeoId: model.vimeoId,
            //     );
            //   },
            // );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
