import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/screens/webinars/widget_models/webinar_screen_wm.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//catalog_webinar
class WebinarScreen extends CoreMwwmWidget<WebinarScreenWM>
    implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final WebinarItemModel model;

  WebinarScreen({
    required this.controller,
    required this.model,
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

class _WebinarsScreenState
    extends WidgetState<WebinarScreen, WebinarScreenWM> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: widget.controller,
          physics: const BouncingScrollPhysics(),
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
        ),
        bottomNavigationBar: StreamedStateBuilder<bool>(
          streamedState: wm.isEnough,
          builder: (_, isEnough) => CustomFloatingActionButton(
            text:
                isEnough ? 'Перейти к заказу' : 'Не хватает ${wm.difference} б',
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
