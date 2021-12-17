import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/sheets/widgets/warning_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
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
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: widget.controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              //* Проверка, растягивать ли изображение на всё доступное пространство

                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                child: Image.network(
                                  widget.model.picture,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: StaticData.sidePadding,
                                ),
                                child: Text(
                                  widget.model.name,
                                  style: AppStyles.h1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),

                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 30,
                                ),
                                child: ButtonContent(
                                  price: '${widget.model.price}',
                                  textStyle: AppStyles.h1,
                                ),
                              ),
                            ],
                          ),
                          CustomSliverAppbar.toPop(
                            icon: Container(),
                            key: widget.key,
                          ),
                        ],
                      ),
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
        ),
        bottomNavigationBar: CustomFloatingActionButton(
          text: wm.isEnough
              ? 'Получить поощрение ${widget.model.priceToString} б'
              : 'Нехватает ${wm.difference.formatString} б',
          withInfo: false,
          icon: Container(),
          onPressed: wm.buttonAction,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
        Keys.bottomSheetItemsNav.currentState!.pushNamed(
          '/verification_partners',
          arguments: SheetScreenArguments(model: itemModel),
        );
      } else {
        Keys.bottomSheetItemsNav.currentState!.pushNamed(
          '/add_points',
        );
      }
    });
  }
}
