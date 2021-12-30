import 'package:bausch/exceptions/custom_exception.dart';
import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/sections/home/widgets/offer_widget.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/offers/offer_type.dart';
import 'package:bausch/widgets/offers/offers_section_wm.dart';
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
      loadingChild: const Center(
        child: AnimatedLoader(),
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
                  onClose: () => wm.removeOfferAction(offer),
                  onPressed: () => showTargetBottomSheet(offer),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> showTargetBottomSheet(Offer offer) async {
    switch (offer.target) {
      case 'program':
        showSheet<void>(
          context,
          SimpleSheetModel(name: 'Программа подбора', type: 'program'),
        );
        break;

      case 'profile':
        await Keys.mainContentNav.currentState!.pushNamed(
          '/profile',
        );
        break;

      case 'content':
        if (offer.html == null || offer.html!.isEmpty) {
          showTopError(
            const CustomException(title: 'Страница не найдена'),
          );
        } else {
          showSheet<Offer>(
            context,
            SimpleSheetModel(name: 'Content', type: 'content'),
            offer,
            '/content',
          );
        }

        break;

      // TODO(Nikolay): Уточнить add_point (Нет данных).
      case 'add_points':
        showSheet<void>(
          context,
          SimpleSheetModel(name: 'Добавить баллы', type: 'add_points'),
        );
        break;
    }
  }
}