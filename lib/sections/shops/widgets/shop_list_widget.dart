import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/widgets/shop_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';

class ShopListWidget extends StatelessWidget {
  final List<ShopModel> shopList;
  const ShopListWidget({
    required this.shopList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        StaticData.sidePadding,
        0,
        StaticData.sidePadding,
        20,
      ),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, i) => ShopWidget(
        shopModel: shopList[i],
      ),
      separatorBuilder: (context, index) => const SizedBox(
        height: 4,
      ),
      itemCount: shopList.length,
    );
  }
}
