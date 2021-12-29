import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/home/sections/offers/offer_type.dart';
import 'package:bausch/sections/home/sections/offers/offers_section.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/material.dart';

class ConsultationScreenArguments {
  final ConsultationItemModel model;

  ConsultationScreenArguments({
    required this.model,
  });
}

//catalog_online_consultation
class ConsultationScreen extends StatefulWidget
    implements ConsultationScreenArguments {
  final ScrollController controller;
  @override
  final ConsultationItemModel model;

  const ConsultationScreen({
    required this.controller,
    required this.model,
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
    model = widget.model;
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.all(18),
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
                  widget.model,
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
                        '${model.length} ${HelpFunctions.wordByCount(
                          model.length,
                          [
                            'минут',
                            'минута',
                            'минуты',
                          ],
                        )}',
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
          sliver: SliverToBoxAdapter(
            child: OffersSection(
              type: OfferType.onlineConsultation,
            ),
          ),
        ),
      ],
      bottomNavBar: CustomFloatingActionButton(
        // TODO(Nikolay): Вопрос.
        text: 'Получить поощрение ${model.priceToString} б',
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/verification_consultation',
            arguments: ItemSheetScreenArguments(model: model),
          );
        },
      ),
    );
  }
}
