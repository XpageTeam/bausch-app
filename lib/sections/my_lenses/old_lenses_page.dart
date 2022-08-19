import 'package:bausch/packages/bottom_sheet/src/flexible_bottom_sheet_route.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/activate_lenses_sheet.dart';
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
    return myLensesWM.previousLenses.isEmpty
        ? const Center(
            child: Text(
              'Здесь будет храниться информация о линзах, которые вы носили раньше',
              style: AppStyles.p1Grey,
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myLensesWM.previousLenses.length,
            itemBuilder: (_, index) => Padding(
              padding: EdgeInsets.only(
                bottom: index != myLensesWM.previousLenses.length - 1 ? 4 : 0,
              ),
              child: WhiteContainerWithRoundedCorners(
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
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
                                myLensesWM.previousLenses[index],
                                style: AppStyles.h2,
                              ),
                              const Text(
                                'срок действия',
                                style: AppStyles.p1,
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Правая',
                                          style: AppStyles.p1,
                                        ),
                                        Text(
                                          'пункт 2',
                                          style: AppStyles.p1Grey,
                                        ),
                                        Text(
                                          'пункт 3',
                                          style: AppStyles.p1Grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Левая',
                                          style: AppStyles.p1,
                                        ),
                                        Text(
                                          'пункт 2',
                                          style: AppStyles.p1Grey,
                                        ),
                                        Text(
                                          'пункт 3',
                                          style: AppStyles.p1Grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 100,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GreyButton(
                      text: 'Сделать активными',
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: StaticData.sidePadding,
                      ),
                      onPressed: () async {
                        await showFlexibleBottomSheet<void>(
                          useRootNavigator: false,
                          minHeight: 0,
                          initHeight: 0.95,
                          maxHeight: 0.95,
                          anchors: [0, 0.6, 0.95],
                          context: context,
                          isCollapsible: true,
                          builder: (context, controller, d) {
                            return SheetWidget(
                              child: ActivateLensesSheet(
                                title: myLensesWM.previousLenses[index],
                                onActivate: () {
                                  myLensesWM
                                      .switchAction(MyLensesPage.currentLenses);
                                },
                              ),
                              withPoints: false,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
