import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/sections/sheets/screens/partners/widget_models/partners_verification_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:bausch/widgets/text/remaining_points_text.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class PartnersVerification extends CoreMwwmWidget<PartnersVerificationWM> {
  final ScrollController controller;
  final PartnersItemModel model;

  PartnersVerification({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => PartnersVerificationWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  WidgetState<PartnersVerification, PartnersVerificationWM>
      createWidgetState() => _PartnersVerificationState();
}

class _PartnersVerificationState
    extends WidgetState<PartnersVerification, PartnersVerificationWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.all(18),
      ),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: StaticData.sidePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 78,
                    ),
                    Text(
                      'Подтвердите заказ',
                      style: AppStyles.h1,
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'После подтверждения мы спишем баллы, и вы получите промокод',
                          style: AppStyles.p1,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    BigCatalogItem(
                      model: widget.model,
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    RemainingPointsText(
                      remains: wm.remains,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      bottomNavBar: StreamedStateBuilder<bool>(
        streamedState: wm.loadingState,
        builder: (_, isLoading) {
          return isLoading
              ? const CustomFloatingActionButton(
                  text: '',
                  icon: UiCircleLoader(),
                )
              : CustomFloatingActionButton(
                  text: 'Потратить ${widget.model.price} б',
                  icon: Container(),
                  onPressed: wm.spendPointsAction,
                );
        },
      ),
    );
  }
}
