import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:bausch/widgets/offers/offers_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  num? userPoints;

  late bool isPointsEnough;

  Color iconColor = AppTheme.mystic;

  @override
  void initState() {
    super.initState();
    model = widget.model;

    userPoints = Provider.of<UserWM>(context, listen: false)
        .userData
        .value
        .data
        ?.balance
        .available;

    isPointsEnough = userPoints != null && userPoints! - model.price >= 0;
  }

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      onScrolled: (offset) {
        if (offset > 60) {
          if (iconColor != AppTheme.turquoiseBlue) {
            setState(() {
              iconColor = AppTheme.turquoiseBlue;
            });
          }
        } else {
          setState(() {
            iconColor = AppTheme.mystic;
          });
        }
      },
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        iconColor: iconColor,
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
                      if (model.length != null)
                        Image.asset(
                          'assets/icons/time.png',
                          height: 16,
                        ),
                      if (model.length != null)
                        const SizedBox(
                          width: 4,
                        ),
                      if (model.length != null)
                        Text(
                          '${model.length} ${HelpFunctions.wordByCount(
                            model.length!,
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
        text: isPointsEnough
            ? 'Получить поощрение ${model.priceToString} б'
            : 'Накопить баллы',
        icon: isPointsEnough
            ? null
            : const Icon(
                Icons.add,
                color: AppTheme.mineShaft,
              ),
        onPressed: () {
          isPointsEnough
              ? Navigator.of(context).pushNamed(
                  '/verification_consultation',
                  arguments: ItemSheetScreenArguments(model: model),
                )
              : Navigator.of(context).pushNamed(
                  '/add_points',
                  arguments: ItemSheetScreenArguments(model: model),
                );
        },
      ),
    );
  }
}
