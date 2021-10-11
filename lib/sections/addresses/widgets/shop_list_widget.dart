import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/addresses/widgets/shop_widget.dart';
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
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
