import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:flutter/material.dart';

class AddItem extends StatelessWidget {
  final AddItemModel model;
  const AddItem({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Keys.bottomSheetWithoutItemsNav.currentState!
            .pushNamed('/addpoints_details');
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    model.title,
                    style: AppStyles.h3,
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  AutoSizeText(
                    model.subtitle,
                    style: AppStyles.p1Grey,
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
      ),
    );
  }
}
