import 'package:bausch/packages/bottom_sheet/bottom_sheet.dart';
import 'package:bausch/sections/select_optic/widgets/bottom_sheet_content.dart';
import 'package:bausch/sections/select_optic/widgets/shop_container.dart';
import 'package:bausch/sections/select_optic/widgets/shop_container_with_button.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ShopListWidget extends StatelessWidget {
  final List<OpticShop> shopList;
  final Type containerType;

  final void Function(OpticShop shop) onOpticShopSelect;

  const ShopListWidget({
    required this.shopList,
    required this.containerType,
    required this.onOpticShopSelect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return shopList.isEmpty
        ? const Center(
            child: Text(
              'Пусто',
              style: AppStyles.p1,
            ),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.only(
              right: StaticData.sidePadding,
              left: StaticData.sidePadding,
              bottom: 20,
            ),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: shopList
                  .map(
                    (shop) => Container(
                      margin: shopList.last == shop
                          ? null
                          : const EdgeInsets.only(bottom: 4),
                      child: containerType == ShopContainerWithButton
                          ? ShopContainerWithButton(
                              shop: shop,
                              onOpticShopSelect: (selectedShop) {
                                final mediaQuery =
                                    MediaQuery.of(Keys.mainNav.currentContext!);
                                final screenHeight = mediaQuery.size.height;
                                final maxHeight = (screenHeight -
                                        mediaQuery.viewPadding.top) /
                                    screenHeight;
                                showFlexibleBottomSheet<void>(
                                  context: context,
                                  minHeight: 0,
                                  initHeight: 0.4,
                                  maxHeight: maxHeight,
                                  anchors: [0, 0.4, maxHeight],
                                  isModal: false,
                                  // barrierColor: Colors.transparent,
                                  builder: (ctx, controller, _) =>
                                      BottomSheetContentOther(
                                    controller: controller,
                                    title: shop.title,
                                    subtitle: shop.address,
                                    phones: shop.phones,
                                    site: shop.site,
                                    features: shop is OpticShopForCertificate
                                        ? shop.features
                                        : null,
                                    // additionalInfo:
                                    //     'Скидкой можно воспользоваться в любой из оптик сети.',
                                    onPressed: () {
                                      onOpticShopSelect(shop);
                                      Navigator.of(context).pop();
                                      //   ..pop();
                                    },
                                    btnText: 'Показать на карте',
                                  ),
                                );
                              },
                            )
                          : ShopContainer(shop: shop),
                    ),
                  )
                  .toList()
                ..add(
                  Container(
                    height: 40,
                  ),
                ),
            ),
          );
  }
}
