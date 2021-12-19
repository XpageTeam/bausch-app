import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/screens/webinars/widget_models/webinar_verification_wm.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class WebinarVerification extends CoreMwwmWidget<WebinarVerificationWM> {
  final ScrollController controller;
  final CatalogItemModel model;
  WebinarVerification({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => WebinarVerificationWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<WebinarVerificationWM>, WebinarVerificationWM>
      createWidgetState() => _WebinarVerificationState();
}

class _WebinarVerificationState
    extends WidgetState<WebinarVerification, WebinarVerificationWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.all(18),
        //icon: Container(height: 1),
        //iconColor: AppTheme.mystic,
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
                          'После подтверждения мы спишем баллы, и вы получите доступ к записи',
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
                    if (wm.remains >= 0)
                      Text(
                        'После заказа у вас останется ${wm.remains} ${HelpFunctions.wordByCount(
                          wm.remains,
                          [
                            'баллов',
                            'балл',
                            'балла',
                          ],
                        )}',
                        style: AppStyles.p1,
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
                  // icon: CircularProgressIndicator.adaptive(),
                  icon: AnimatedLoader(),
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
