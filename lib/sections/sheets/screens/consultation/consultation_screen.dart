import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/screens/consultation/widget_model/consultation_screen_wm.dart';
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
import 'package:surf_mwwm/surf_mwwm.dart';

class ConsultationScreenArguments {
  final ConsultationItemModel model;

  ConsultationScreenArguments({
    required this.model,
  });
}

//catalog_online_consultation
class ConsultationScreen extends CoreMwwmWidget<ConsultationScreenWM>
    implements ConsultationScreenArguments {
  final ScrollController controller;
  @override
  final ConsultationItemModel model;

  ConsultationScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) {
            return ConsultationScreenWM(
              context: context,
              itemModel: model,
            );
          },
        );

  @override
  WidgetState<CoreMwwmWidget<ConsultationScreenWM>, ConsultationScreenWM>
      createWidgetState() => _ConsultationScreenState();
}

class _ConsultationScreenState
    extends WidgetState<ConsultationScreen, ConsultationScreenWM> {
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
          wm.colorState.accept(AppTheme.turquoiseBlue);
        } else {
          wm.colorState.accept(AppTheme.mystic);
        }
      },
      appBar: StreamedStateBuilder<Color>(
        streamedState: wm.colorState,
        builder: (_, color) {
          return CustomSliverAppbar(
            padding: const EdgeInsets.all(18),
            iconColor: color,
          );
        },
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
                  // wm.difference > 0
                  //     ? PointsInfo(
                  //         text: 'Не хватает ${wm.difference}',
                  //       )
                  //     :
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
