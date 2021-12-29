import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/sections/home/sections/offers/offer_type.dart';
import 'package:bausch/sections/home/sections/offers/offers_section.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/screens/parners/widget_models/partners_screen_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//catalog_partners
class PartnersScreen extends CoreMwwmWidget<PartnersScreenWM> {
  final ScrollController controller;
  final PartnersItemModel model;

  PartnersScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => PartnersScreenWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<PartnersScreenWM>, PartnersScreenWM>
      createWidgetState() => _PartnersScreenState();
}

class _PartnersScreenState
    extends WidgetState<PartnersScreen, PartnersScreenWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        icon: Container(height: 1),
        //iconColor: AppTheme.mystic,
      ),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
                child: TopSection.partners(
                  widget.model,
                  widget.key,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    InfoSection(
                      text: widget.model.previewText,
                      secondText: widget.model.detailText,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    OffersSection(
                      type: OfferType.promoCodeImmediately,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      bottomNavBar: CustomFloatingActionButton(
        text: wm.isEnough
            ? 'Получить поощрение ${widget.model.priceToString} б'
            : 'Накопить баллы',
        withInfo: false,
        icon: wm.isEnough
            ? null
            : const Icon(
                Icons.add,
                color: AppTheme.mineShaft,
              ),
        onPressed: wm.buttonAction,
      ),
    );
  }
}
