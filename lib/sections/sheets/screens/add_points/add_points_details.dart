import 'package:bausch/models/add_item_model.dart';
import 'package:bausch/sections/sheets/product_sheet/info_section.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:bausch/widgets/buttons/focus_button.dart';
import 'package:flutter/material.dart';

//* Add_points
//* add
class AddPointsDetails extends StatelessWidget {
  final AddItemModel model;
  final ScrollController controller;
  const AddPointsDetails({
    required this.model,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: controller,
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
                                  style: AppStyles.h2,
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
                                child: ButtonContent(price: model.price),
                              ),
                            ],
                          ),
                          CustomSliverAppbar.toPop(
                            icon: Container(),
                            key: key,
                            rightKey: Keys.bottomSheetWithoutItemsNav,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const InfoSection(),
                    const SizedBox(
                      height: 4,
                    ),
                    Column(
                      children: [
                        const FocusButton(labelText: 'Привязать аккаунт'),
                        const SizedBox(
                          height: 4,
                        ),
                        BlueButtonWithText(
                          text: 'Привязать аккаунт',
                          onPressed: () {
                            Keys.bottomSheetWithoutItemsNav.currentState!
                                .pushNamed('/final_addpoints');
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
        ),
        // floatingActionButton: Padding(
        //   padding: const EdgeInsets.only(
        //     right: StaticData.sidePadding,
        //     left: StaticData.sidePadding,
        //     bottom: 4,
        //   ),
        //   child: Column(
        //     children: [
        //       FocusButton(labelText: 'Привязать аккаунт'),
        //       BlueButtonWithText(text: 'text'),
        //     ],
        //   ),
        // ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
