import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class DiscountOpticsVerification
    extends CoreMwwmWidget<DiscountOpticsVerificationWM> {
  final ScrollController controller;

  DiscountOpticsVerification({
    required this.controller,
    required PromoItemModel model,
    required DiscountOptic discountOptic,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => DiscountOpticsVerificationWM(
            context: context,
            discountOptic: discountOptic,
            itemModel: model,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<DiscountOpticsVerificationWM>,
          DiscountOpticsVerificationWM>
      createWidgetState() => _DiscountOpticsVerificationState();
}

class _DiscountOpticsVerificationState extends WidgetState<
    DiscountOpticsVerification, DiscountOpticsVerificationWM> {
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSliverAppbar.toPop(
                          icon: NormalIconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_sharp,
                              size: 20,
                            ),
                            onPressed: Navigator.of(context).pop,
                          ),
                          key: widget.key,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Подтвердите заказ',
                          style: AppStyles.h2,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DiscountInfo(text: 'Скидка 500 ₽'),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              'в оптике ${wm.discountOptic.title}',
                              style: AppStyles.h2,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        BigCatalogItem(
                          model: wm.itemModel,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        if (wm.difference <= 0)
                          Text(
                            'После заказа у вас останется ${wm.difference} баллов',
                            style: AppStyles.p1,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: CustomFloatingActionButton(
          text: wm.difference >= 0
              ? 'Потратить ${wm.itemModel.price} б'
              : 'Нехватает ${wm.difference} б',
          onPressed: wm.buttonAction,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}

class DiscountOpticsVerificationWM extends WidgetModel {
  final BuildContext context;
  final DiscountOptic discountOptic;
  final PromoItemModel itemModel;

  final buttonAction = VoidAction();

  late int points;
  late int difference;

  DiscountOpticsVerificationWM({
    required this.context,
    required this.discountOptic,
    required this.itemModel,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onLoad() {
    points = Provider.of<UserWM>(context)
            .userData
            .value
            .data
            ?.balance
            .available
            .toInt() ??
        0;
    difference = points - itemModel.price;

    super.onLoad();
  }

  @override
  void onBind() {
    buttonAction.bind((p0) {
      if (difference < 0) {
        Keys.bottomSheetItemsNav.currentState!.pushNamed(
          '/add_points',
          arguments: SheetScreenArguments(model: itemModel),
        );
      } else {
        Keys.bottomSheetItemsNav.currentState!.pushNamed(
          '/final_discount_optics',
          arguments: SheetScreenArguments(model: itemModel),
        );
      }
    });
    super.onBind();
  }
}
