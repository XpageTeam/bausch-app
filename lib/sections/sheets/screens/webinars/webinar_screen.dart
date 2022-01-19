import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/orders_data/order_data.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/screens/webinars/widget_models/webinar_screen_wm.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//catalog_webinar
class WebinarScreen extends CoreMwwmWidget<WebinarScreenWM>
    implements ItemSheetScreenArguments {
  final ScrollController controller;

  @override
  final CatalogItemModel model;

  @override
  final OrderData? orderData;

  WebinarScreen({
    required this.controller,
    required this.model,
    this.orderData,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => WebinarScreenWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<WebinarScreenWM>, WebinarScreenWM>
      createWidgetState() => _WebinarsScreenState();
}

class _WebinarsScreenState extends WidgetState<WebinarScreen, WebinarScreenWM> {
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
                TopSection.webinar(
                  widget.model,
                  widget.key,
                ),
                const SizedBox(
                  height: 4,
                ),
                InfoSection(
                  text: widget.model.previewText,
                  secondText: widget.model.detailText,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
      bottomNavBar: StreamedStateBuilder<bool>(
        streamedState: wm.isEnough,
        builder: (_, isEnough) => CustomFloatingActionButton(
          text: isEnough ? 'Перейти к заказу' : 'Накопить баллы',
          icon: isEnough
              ? null
              : const Icon(
                  Icons.add,
                  color: AppTheme.mineShaft,
                ),
          // '${HelpFunctions.wordByCount(
          //     wm.difference,
          //     [
          //       'баллов',
          //       'балла',
          //       'баллов',
          //     ],
          //   )}',
          onPressed: wm.buttonAction,
        ),
      ),
    );
  }
}
