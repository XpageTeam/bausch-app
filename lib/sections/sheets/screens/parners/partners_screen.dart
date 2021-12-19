import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/product_sheet/top_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                    // TODO(Nikolay): Информация для вывода рекламы.
                    Warning.advertisment(),
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
            : 'Нехватает ${wm.difference.formatString} б',
        withInfo: false,
        icon: Container(),
        onPressed: wm.buttonAction,
      ),
    );
  }
}

class PartnersScreenWM extends WidgetModel {
  final BuildContext context;
  final PartnersItemModel itemModel;

  final buttonAction = VoidAction();
  bool isEnough = false;
  int difference = 0;

  PartnersScreenWM({
    required this.context,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    final points = Provider.of<UserWM>(
          context,
          listen: false,
        ).userData.value.data?.balance.available.toInt() ??
        0;
    difference = itemModel.price - points;
    isEnough = difference <= 0;

    super.onLoad();
  }

  @override
  void onBind() {
    buttonAction.bind((p0) {
      if (isEnough) {
        Navigator.of(context).pushNamed(
          '/verification_partners',
          arguments: ItemSheetScreenArguments(model: itemModel),
        );
      } else {
        Navigator.of(context).pushNamed(
          '/add_points',
        );
      }
    });
  }
}
