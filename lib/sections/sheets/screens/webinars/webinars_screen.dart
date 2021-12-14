
import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//catalog_webinar
class WebinarsScreen extends CoreMwwmWidget<WebinarsScreenWM>
    implements SheetScreenArguments {
  final ScrollController controller;

  @override
  final WebinarItemModel model;

  WebinarsScreen({
    required this.controller,
    required this.model,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => WebinarsScreenWM(
            context: context,
            itemModel: model,
          ),
        );

  @override
  State<WebinarsScreen> createState() => _WebinarsScreenState();

  @override
  WidgetState<CoreMwwmWidget<WebinarsScreenWM>, WebinarsScreenWM>
      createWidgetState() => _WebinarsScreenState();
}

class _WebinarsScreenState
    extends WidgetState<WebinarsScreen, WebinarsScreenWM> {
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
            text: isEnough ? 'Перейти к заказу' : 'Накопить баллы',
            icon: isEnough
                ? null
                : const Icon(
                    Icons.add,
                    color: AppTheme.mineShaft,
                  ),
            onPressed: wm.buttonAction,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class WebinarsScreenWM extends WidgetModel {
  final BuildContext context;
  final CatalogItemModel itemModel;

  final isEnough = StreamedState<bool>(true);
  final buttonAction = VoidAction();

  late int points;

  WebinarsScreenWM({
    required this.context,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    points = Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data?.balance.available.toInt() ??
        0;

    isEnough.accept(points > itemModel.price);

    super.onLoad();
  }

  @override
  void onBind() {
    buttonAction.bind(
      (_) {
        if (isEnough.value) {
          Keys.bottomSheetItemsNav.currentState!.pushNamed(
            '/verification_webinar',
            arguments: SheetScreenArguments(model: itemModel),
          );
        } else {
          // TODO(Nikolay): Здесь возможны проблемы.
          Keys.bottomSheetItemsNav.currentState!.pushReplacementNamed(
            '/add_points',
          );
        }
      },
    );

    super.onBind();
  }
}
