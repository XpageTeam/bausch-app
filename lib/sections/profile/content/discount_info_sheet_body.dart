import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/sheets/widgets/container_with_promocode.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/simple_webview_widget.dart';
import 'package:flutter/material.dart';

class DiscountInfoSheetBodyArgs {
  final String title;
  final String? code;
  final String date;
  final String type;
  final String? link;

  DiscountInfoSheetBodyArgs({
    required this.title,
    required this.date,
    required this.type,
    this.code,
    this.link,
  });
}

class DiscountInfoSheetBody extends StatelessWidget {
  final DiscountInfoSheetBodyArgs args;
  final ScrollController controller;

  const DiscountInfoSheetBody({
    required this.args,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.sulu,
      controller: controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(height: 1),
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 78,
                ),
                Text(
                  args.title,
                  style: AppStyles.h1,
                ),
                const SizedBox(
                  height: 40,
                ),
                if (args.code != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: ContainerWithPromocode(
                      promocode: args.code!,
                    ),
                  ),
                Text(
                  'Истечёт ${args.date} года. Промокод хранится в личном кабинете. Введи его при оформлении товара в интернет-магазине',
                  style: AppStyles.p1,
                ),
              ],
            ),
          ),
        ),
      ],
      bottomNavBar: ColoredBox(
        color: AppTheme.mystic,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                20,
                StaticData.sidePadding,
                8,
              ),
              child: BlueButton(
                onPressed: () {
                  if (args.link != null) {
                    openSimpleWebView(context, url: args.link!);
                  }
                },
                children: [
                  Text(
                    args.type == 'offline'
                        ? 'Перейти на сайт оптики'
                        : 'Перейти в интернет-магазин',
                    style: AppStyles.h2,
                  ),
                  const SizedBox(width: 9),
                  Image.asset(
                    'assets/icons/link.png',
                    height: 15,
                  ),
                ],
              ),
            ),
            const ColoredBox(
              color: AppTheme.mystic,
              child: BottomInfoBlock(
                topPadding: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
