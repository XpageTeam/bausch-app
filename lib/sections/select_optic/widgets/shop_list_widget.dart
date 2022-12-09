import 'package:bausch/sections/select_optic/widgets/shop_container.dart';
import 'package:bausch/sections/select_optic/widgets/shop_container_with_button.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/anti_glow_behavior.dart';
import 'package:bausch/widgets/only_bottom_bouncing_scroll_physics.dart';
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
        : ScrollConfiguration(
            behavior: const AntiGlowBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                right: StaticData.sidePadding,
                left: StaticData.sidePadding,
                bottom: 20,
              ),
              physics: const OnlyBottomBouncingScrollPhysics(),
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
                                  onOpticShopSelect(shop);
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
            ),
          );
  }
}
