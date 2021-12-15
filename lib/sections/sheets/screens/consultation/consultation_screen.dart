import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/material.dart';

//catalog_online_consultation
class ConsultationScreen extends StatefulWidget {
  final ScrollController controller;
  final CatalogItemModel item;
  const ConsultationScreen({
    required this.controller,
    required this.item,
    Key? key,
  }) : super(key: key);

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  late ConsultationItemModel model;

  @override
  void initState() {
    super.initState();
    model = widget.item as ConsultationItemModel;
  }

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
          controller: widget.controller,
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
                    TopSection.consultation(
                      widget.item as ConsultationItemModel,
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/time.png',
                              height: 16,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${model.length} минут',
                              style: AppStyles.p1,
                            ),
                          ],
                        ),
                      ),
                      widget.key,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const InfoSection(),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Warning.advertisment(),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomFloatingActionButton(
          text: 'Потратить ${model.priceToString} б',
          onPressed: () {
            Keys.bottomSheetWithoutItemsNav.currentState!.pushNamed(
              '/verification_consultation',
              arguments: SheetScreenArguments(model: model),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
