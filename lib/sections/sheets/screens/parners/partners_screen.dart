import 'package:bausch/models/catalog_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
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
                    WhiteRoundedContainer(
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              //* Проверка, растягивать ли изображение на всё доступное пространство

                              Image.asset(
                                'assets/temp/image.png',
                                //height: null,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: StaticData.sidePadding,
                                ),
                                child: Text(
                                  model.name,
                                  style: AppStyles.h2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 30,
                                ),
                                child: ButtonContent(price: model.price),
                              ),
                            ],
                          ),
                          CustomSliverAppbar.toPop(icon: Container(), key: key),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const InfoSection(),
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
        floatingActionButton: CustomFloatingActionButton(
          text: 'Получить поощрение',
          icon: Container(),
          onPressed: () {
            Keys.bottomSheetItemsNav.currentState!.pushNamed(
              '/verification_partners',
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
