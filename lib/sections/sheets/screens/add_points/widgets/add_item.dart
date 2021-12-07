import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:flutter/material.dart';

//* Элемент, после нажатия на который, происходит переход на страницу добавления баллов
class AddItem extends StatelessWidget {
  final AddItemModel model;
  const AddItem({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // if (model.type == 'survey') {
        //   Keys.bottomSheetWithoutItemsNav.currentState!
        //       .pushNamed('/addpoints_survey');
        // }
        Keys.simpleBottomSheetNav.currentState!.pushNamed('/addpoints_details');
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        model.title,
                        style: AppStyles.h2,
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      AutoSizeText(
                        model.subtitle,
                        style: AppStyles.p1,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                ButtonContent(price: '+${model.price}'),
              ],
            ),
            // if (model.type == 'birthday')
            //   Padding(
            //     padding: const EdgeInsets.only(top: 30),
            //     child: TextButton(
            //       onPressed: () {},
            //       style: TextButton.styleFrom(
            //         backgroundColor: AppTheme.mystic,
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: StaticData.sidePadding,
            //         ),
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Padding(
            //             padding: const EdgeInsets.only(top: 26, bottom: 28),
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Заполнить профиль',
            //                   style: AppStyles.h2,
            //                 ),
            //               ],
            //             ),
            //           ),
            //           const Icon(
            //             Icons.arrow_forward_ios_sharp,
            //             size: 18,
            //             color: AppTheme.mineShaft,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
