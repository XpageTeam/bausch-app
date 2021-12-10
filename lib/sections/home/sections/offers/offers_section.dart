import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/sections/home/sections/offers/offers_section_wm.dart';
import 'package:bausch/sections/home/widgets/offer_widget.dart';
import 'package:bausch/sections/sheets/screens/program/program_screen.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class OffersSection extends CoreMwwmWidget<OffersSectionWM> {
  OffersSection({
    required OfferType type,
    int? goodID,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => OffersSectionWM(
            type: type,
            goodID: goodID,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<OffersSectionWM>, OffersSectionWM>
      createWidgetState() => _OffersSectionState();
}

class _OffersSectionState extends WidgetState<OffersSection, OffersSectionWM> {
  @override
  Widget build(BuildContext context) {
    return EntityStateBuilder<List<Offer>>(
      streamedState: wm.offersStreamed,
      errorBuilder: (_, e) => Text(
        'Ошибка',
        style: AppStyles.h1.copyWith(
          color: Colors.red,
        ),
      ),
      builder: (c, offers) => Column(
        children: offers
            .map(
              (offer) => Padding(
                padding: EdgeInsets.only(
                  bottom: offer != offers.last ? 4.0 : 0.0,
                ),
                child: OfferWidget(
                  offer: offer,
                  onClose: () {},
                  onPressed: () {
                    showFlexibleBottomSheet<void>(
                      useRootNavigator: true,
                      minHeight: 0,
                      isCollapsible: false,
                      initHeight: 0.95,
                      maxHeight: 0.95,
                      anchors: [0, 0.6, 0.95],
                      context: c,
                      builder: (_, controller, d) =>
                          ProgramScreen(controller: controller),
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
