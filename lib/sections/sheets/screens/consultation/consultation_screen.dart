import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
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
    return CustomSheetScaffold(
      controller: widget.controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(
          height: 1,
          width: 1,
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
                TopSection.consultation(
                  widget.item as ConsultationItemModel,
                  Row(
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
                  widget.key,
                ),
                const SizedBox(
                  height: 4,
                ),
                InfoSection(
                  text: model.previewText,
                  secondText: model.detailText,
                ),
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
                Warning.advertisment(
                  name: 'SmartMed',
                  link: 'smartmed.pro',
                  description:
                      'Скачайте приложение и общайтесь с компетентными врачами МЕДСИ, не выходя из дома.',
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
      bottomButton: CustomFloatingActionButton(
        text: 'Получить поощрение ${model.priceToString} б',
        onPressed: () {
          Keys.bottomSheetWithoutItemsNav.currentState!.pushNamed(
            '/verification_consultation',
            arguments: SheetScreenArguments(model: model),
          );
        },
      ),
    );
  }
}
