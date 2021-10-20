import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/widgets/map_with_buttons.dart';
import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
import 'package:flutter/material.dart';

class MapAdapter extends StatelessWidget {
  final ShopFilterState state;
  final List<ShopModel> shopList;
  const MapAdapter({
    required this.state,
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MapWithButtons(
      shopList: shopList
          .where(
            (shop) =>
                state is! ShopFilterChange ||
                state.selectedFilters.contains(shop.name),
          )
          .toList(),
    );
  }
}
