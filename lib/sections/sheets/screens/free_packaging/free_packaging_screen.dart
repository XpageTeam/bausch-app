import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/order_registration/order_registration_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/legal_info.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/points_info.dart';
import 'package:flutter/material.dart';

//catalog_free_packaging
class FreePackagingScreen extends StatelessWidget
    implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final CatalogItemModel model;

  const FreePackagingScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.mystic,
      controller: controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(
          height: 1,
        ),
        iconColor: AppTheme.mystic,
      ),
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
                TopSection.packaging(
                  model: model,
                  key: key,
                  leftIcon: const PointsInfo(
                    text: 'Не хватает 2000',
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                InfoSection(
                  text: model.previewText,
                  secondText: model.detailText,
                ),
                // const SizedBox(
                //   height: 12,
                // ),

                // const SizedBox(
                //   height: 160,
                // ),
              ],
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(
            StaticData.sidePadding,
            12,
            StaticData.sidePadding,
            30,
          ),
          sliver: LegalInfo(
            texts: [
              'Адрес доставки должен быть на территории Российской Федерации, за исключением Республики Крым (по правилам программы доставка в Крым и Севастополь не осуществляется).',
              'Бесплатная упаковка будет направлена на указанный адрес не позднее 60 рабочих дней с момента заказа.',
              'Организатор не несёт ответственность за невозможность доставки в связи с некорректным указанием адреса доставки и в случае невозможности связаться с получателем по указанному номеру телефона. Сроки доставки определяются организацией, осуществляющей доставку.',
              'Внешний вид и комплектность подарочных изделий могут отличаться от изображений на сайте.',
            ],
          ),
        ),
      ],
      bottomButton: CustomFloatingActionButton(
        text: 'Перейти к заказу',
        onPressed: () {
          // Keys.mainNav.currentState!.pop();

          // Keys.mainContentNav.currentState!
          //     .pushNamed('/order_registration');

          Keys.mainNav.currentState!.push<void>(
            MaterialPageRoute(
              builder: (context) {
                return const OrderRegistrationScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
