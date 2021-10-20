import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/sections/shops/widgets/shop_list_content.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
import 'package:flutter/material.dart';

class ShopListWidget extends StatelessWidget {
  final List<ShopModel> shopList;
  final Type containerType;
  final ShopFilterState? state;
  const ShopListWidget({
    required this.shopList,
    required this.containerType,
    this.state,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        right: StaticData.sidePadding,
        left: StaticData.sidePadding,
        bottom: 20,
      ),
      child: ShopListWidgetContent(
        containerType: containerType,
        filteredShopList: state != null
            ? shopList
                .where(
                  (shop) =>
                      state! is! ShopFilterChange ||
                      state!.selectedFilters.contains(shop.name),
                )
                .toList()
            : shopList,
      ),
    );
  }
}


// class ShopListWidget extends StatelessWidget {
//   final List<ShopModel> shopList;
//   const ShopListWidget({
//     required this.shopList,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(
//         StaticData.sidePadding,
//         0,
//         StaticData.sidePadding,
//         0,
//       ),
//       child: shopList.isEmpty
//           ? const Align(
//               child: Text(
//                 'Поблизости нет оптик',
//                 style: AppStyles.h2Bold,
//               ),
//             )
//           : CustomScrollView(
//               physics: const BouncingScrollPhysics(),
//               slivers: [
//                 SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (context, i) => Container(
//                       margin: i == shopList.length - 1
//                           ? const EdgeInsets.only(bottom: 20)
//                           : const EdgeInsets.only(bottom: 4),
//                       child: ShopWidget(
//                         shopModel: shopList[i],
//                       ),
//                     ),
//                     childCount: shopList.length,
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

