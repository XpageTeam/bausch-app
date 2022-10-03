import 'package:bausch/help/help_functions.dart';
import 'package:bausch/packages/bottom_sheet/src/flexible_bottom_sheet_route.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_short_description.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/activate_lenses_sheet.dart';
import 'package:bausch/sections/sheets/sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';

class OldLensesPage extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const OldLensesPage({required this.myLensesWM, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return myLensesWM.productHistoryList.value.isEmpty
        ? const Padding(
            padding: EdgeInsets.only(top: 120),
            child: Text(
              'Покажем линзы, которые вы носили раньше',
              style: AppStyles.p1Grey,
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myLensesWM.productHistoryList.value.length,
            itemBuilder: (_, index) => Padding(
              padding: EdgeInsets.only(
                bottom: index != myLensesWM.productHistoryList.value.length - 1
                    ? 4
                    : 0,
              ),
              child: GestureDetector(
                onTap: () async {
                  await showFlexibleBottomSheet<void>(
                    minHeight: 0,
                    initHeight: 0.95,
                    maxHeight: 0.95,
                    anchors: [0, 0.6, 0.95],
                    context: context,
                    builder: (context, controller, d) {
                      return SheetWidget(
                        child: ActivateLensesSheet(
                          productIndex: index,
                          controller: controller,
                          lensProductModel: myLensesWM
                              .productHistoryList.value[index].product!,
                          lensesPairModel:
                              myLensesWM.productHistoryList.value[index],
                          myLensesWM: myLensesWM,
                        ),
                        withPoints: false,
                      );
                    },
                  );
                },
                child: WhiteContainerWithRoundedCorners(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: StaticData.sidePadding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  myLensesWM.productHistoryList.value[index]
                                      .product!.name,
                                  style: AppStyles.h2,
                                ),
                                Text(
                                  myLensesWM.productHistoryList.value[index]
                                              .product!.lifeTime >
                                          1
                                      ? 'Плановой замены \nДо ${myLensesWM.productHistoryList.value[index].product!.lifeTime} суток'
                                      : 'Однодневные',
                                  style: AppStyles.p1,
                                ),
                                Text(
                                  HelpFunctions.pairs(
                                    int.parse(
                                      myLensesWM.productHistoryList.value[index]
                                          .product!.count,
                                    ),
                                  ),
                                  style: AppStyles.p1,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LensShortDescription(
                                        isLeft: true,
                                        pairModel: myLensesWM.productHistoryList
                                            .value[index].left,
                                      ),
                                    ),
                                    Expanded(
                                      child: LensShortDescription(
                                        isLeft: false,
                                        pairModel: myLensesWM.productHistoryList
                                            .value[index].right,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Image.network(
                            myLensesWM
                                .productHistoryList.value[index].product!.image,
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GreyButton(
                        text: 'Сделать активными',
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: StaticData.sidePadding,
                        ),
                        onPressed: () async => myLensesWM.activateOldLenses(
                          pairId:
                              myLensesWM.productHistoryList.value[index].id!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
