import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/sections/sheets/screens/consultation/widget_model/consultation_verification_wm.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:bausch/widgets/text/remaining_points_text.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ConsultationVerification
    extends CoreMwwmWidget<ConsultationVerificationWM> {
  final ScrollController controller;

  ConsultationVerification({
    required this.controller,
    required ConsultationItemModel model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => ConsultationVerificationWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<ConsultationVerificationWM>,
          ConsultationVerificationWM>
      createWidgetState() => _ConsultationVerificationState();
}

class _ConsultationVerificationState
    extends WidgetState<ConsultationVerification, ConsultationVerificationWM> {
  Color iconColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      backgroundColor: AppTheme.mystic,
      controller: widget.controller,
      onScrolled: (offset) {
        if (offset > 60) {
          wm.colorState.accept(AppTheme.turquoiseBlue);
        } else {
          wm.colorState.accept(Colors.white);
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
                    const Text(
                      'Подтвердите заказ',
                      style: AppStyles.h1,
                    ),
                    Column(
                      children: const [
                        SizedBox(
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
                      model: wm.itemModel,
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
                  text: 'Потратить ${wm.itemModel.price} б',
                  icon: Container(),
                  onPressed: wm.spendPointsAction,
                );
        },
      ),
      // bottomNavBar: CustomFloatingActionButton(
      //   text: 'Потратить ${model.price} б',
      //   onPressed: () {
      // Navigator.of(context).pushNamed(
      //   '/final_consultation',
      //   arguments: ItemSheetScreenArguments(model: model),
      // );
      //   },
      // ),
    );
  }
}
