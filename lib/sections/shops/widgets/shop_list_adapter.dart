import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/widgets/shop_list_widget.dart';
import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
import 'package:flutter/material.dart';

class ShopListAdapter extends StatelessWidget {
  final ShopFilterState? state;
  final Type containerType;
  final List<ShopModel> shopList;
  const ShopListAdapter({
    required this.state,
    required this.containerType,
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShopListWidget(
      containerType: containerType,
      state: state,
      shopList: state != null
          ? shopList
              .where(
                (shop) =>
                    state is! ShopFilterChange ||
                    state!.selectedFilters.any(
                      (filter) => filter.title == shop.name,
                    ),
              )
              .toList()
          : shopList,
    );
  }
}
