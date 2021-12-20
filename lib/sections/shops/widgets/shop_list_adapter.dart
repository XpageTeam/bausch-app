import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/widgets/shop_list_widget.dart';
import 'package:flutter/material.dart';

// TODO(Nikolay): .
class ShopListAdapter extends StatelessWidget {
  final Type containerType;
  final List<ShopModel> shopList;

  const ShopListAdapter({
    required this.containerType,
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShopListWidget(
      containerType: containerType,
      shopList: shopList,
    );
  }
}
