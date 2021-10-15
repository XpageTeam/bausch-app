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
    return Container(
      padding: const EdgeInsets.fromLTRB(
        StaticData.sidePadding,
        0,
        StaticData.sidePadding,
        0,
      ),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                shopList.length,
                (i) => Container(
                  margin: i == shopList.length - 1
                      ? const EdgeInsets.only(bottom: 20)
                      : const EdgeInsets.only(bottom: 4),
                  child: ShopWidget(
                    shopModel: shopList[i],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
