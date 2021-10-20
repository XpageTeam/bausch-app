import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/widgets/shop_container.dart';
import 'package:bausch/sections/shops/widgets/shop_container_with_button.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
import 'package:flutter/material.dart';

class ShopListWidgetContent extends StatelessWidget {
  final List<ShopModel> filteredShopList;
  final Type containerType;
  final ShopFilterState state;
  const ShopListWidgetContent({
    required this.filteredShopList,
    required this.containerType,
    required this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: filteredShopList.isEmpty
          ? [
              const Center(
                child: Text(
                  'Пусто',
                  style: AppStyles.p1,
                ),
              ),
            ]
          : filteredShopList
              .map(
                (shop) => Container(
                  margin: filteredShopList.last == shop
                      ? null
                      : const EdgeInsets.only(bottom: 4),
                  child: containerType is ShopContainerWithButton
                      ? ShopContainerWithButton(shop: shop)
                      : ShopContainer(shop: shop),
                  // ShopContainer(shop: shop),
                ),
              )
              .toList(),
    );
  }
}
