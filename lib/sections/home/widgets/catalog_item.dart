import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/buttons/button_with_points.dart';
import 'package:bausch/widgets/discount_info.dart';
import 'package:flutter/material.dart';

class CatalogItem extends StatelessWidget {
  final CatalogItemModel model;
  final VoidCallback? onContainerPressed;
  const CatalogItem({
    required this.model,
    this.onContainerPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onContainerPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: StaticData.sidePadding,
          horizontal: StaticData.sidePadding,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      // model.img ?? 'assets/free-packaging.png',
                      model.picture,
                      height: 100,
                      width: 100,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: Text(
                          model.name,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
                // TODO(Nikolay): Вынести onPressed.
                ButtonWithPoints(
                  price: '${model.price}',
                ),
              ],
            ),
            const DiscountInfo(text: '–500 ₽'),
          ],
        ),
      ),
    );
  }
}


// class DefaultCatalogItem extends StatelessWidget {
//   final CatalogItemModel model;
//   final double rightMargin;
//   final double itemWidth;
//   final VoidCallback? onPressed;

//   const DefaultCatalogItem({
//     required this.model,
//     required this.rightMargin,
//     required this.itemWidth,
//     this.onPressed,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         margin: EdgeInsets.only(right: rightMargin),
//         padding: const EdgeInsets.symmetric(
//           vertical: StaticData.sidePadding,
//           horizontal: StaticData.sidePadding,
//         ),
//         width: itemWidth,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(5),
//         ),
//         child: Stack(
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Image.asset(
//                       model.img ?? 'assets/free-packaging.png',
//                       height: 100,
//                       width: 100,
//                     ),
//                     Flexible(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 8.0,
//                         ),
//                         child: Text(
//                           model.name,
//                           textAlign: TextAlign.center,
//                           softWrap: true,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 ButtonWithPoints(
//                   price: model.price,
//                 ),
//               ],
//             ),
//             const DiscountInfo(text: '–500 ₽'),
//           ],
//         ),
//       ),
//     );
//   }
// }
