import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:flutter/material.dart';

class AddPointsDetailsArguments {
  final AddItemModel model;

  AddPointsDetailsArguments({required this.model});
}

//* Add_points
//* add
class AddPointsDetails extends StatelessWidget
    implements AddPointsDetailsArguments {
  @override
  final AddItemModel model;
  final ScrollController controller;
  const AddPointsDetails({
    required this.model,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: controller,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.all(18),
        iconColor: AppTheme.mystic,
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(12),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                //* Верхний контейнер
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 64,
                          ),
                          Image.asset(
                            model.img,
                            fit: BoxFit.cover,
                            height: 200,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: StaticData.sidePadding,
                            ),
                            child: Text(
                              model.title,
                              style: AppStyles.h1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 30,
                            ),
                            child: ButtonContent(
                              price: model.priceString,
                              textStyle: AppStyles.h1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                InfoSection(
                  text: model.htmlText,
                  secondText: '',
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  children: [
                    if (model.type == 'vk')
                      const FocusButton(labelText: 'Привязать аккаунт'),
                    const SizedBox(
                      height: 4,
                    ),
                    BlueButtonWithText(
                      text: buttonText(model.type!),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/final_addpoints');
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String buttonText(String type) {
    if (type == 'vk') {
      return 'Подписаться на группу';
    } else if (type == 'friend') {
      return 'Отправить ссылку';
    } else if (type == 'overview_social') {
      return 'Прикрепить скриншот';
    } else if (type == 'overview') {
      return 'Прикрепить скриншот';
    } else {
      return 'Далее';
    }
  }
}
