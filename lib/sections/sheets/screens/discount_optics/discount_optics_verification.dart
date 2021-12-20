import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/discount_optic/discount_optic.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_verification_wm.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:bausch/widgets/catalog_item/big_catalog_item.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:bausch/widgets/loader/animated_loader.dart';
import 'package:bausch/widgets/text/remaining_points_text.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class DiscountOpticsVerification
    extends CoreMwwmWidget<DiscountOpticsVerificationWM> {
  final ScrollController controller;

  DiscountOpticsVerification({
    required this.controller,
    required PromoItemModel model,
    required DiscountOptic discountOptic,
    required DiscountType discountType,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) => DiscountOpticsVerificationWM(
            context: context,
            discountOptic: discountOptic,
            itemModel: model,
            discountType: discountType,
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
                        CustomSliverAppbar(
                          key: widget.key,
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
                              'в ${wm.discountType == DiscountType.offline ? 'оптике' : 'онлайн-магазине'} ${wm.discountOptic.title}',
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
        ),
        bottomNavigationBar: StreamedStateBuilder<bool>(
          streamedState: wm.loadingState,
          builder: (_, isLoading) {
            return isLoading
                ? const CustomFloatingActionButton(
                    text: '',
                    icon: AnimatedLoader(),
                  )
                : CustomFloatingActionButton(
                    text: 'Потратить ${wm.itemModel.price} б',
                    icon: Container(),
                    onPressed: wm.spendPointsAction,
                  );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
