import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/sections/home/sections/offers/offers_section_wm.dart';
import 'package:bausch/sections/home/widgets/offer_widget.dart';
import 'package:bausch/theme/styles.dart';
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
  _OffersSectionState createState() => _OffersSectionState();

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
      builder: (_, offers) => Column(
        children: offers
            .map(
              (offer) => Padding(
                padding: EdgeInsets.only(
                  bottom: offer != offers.last ? 4.0 : 0.0,
                ),
                child: OfferWidget(
                  offer: offer,
                  onClose: () {},
                  onPressed: () {},
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
