import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_date_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ChosenLenses extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const ChosenLenses({required this.myLensesWM, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteContainerWithRoundedCorners(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: StaticData.sidePadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamedStateBuilder<LensProductModel?>(
            streamedState: myLensesWM.currentProduct,
            builder: (_, currentProduct) => currentProduct != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              myLensesWM.currentProduct.value!.name,
                              style: AppStyles.h2,
                            ),
                            Text(
                              'Плановой замены \n${currentProduct.lifeTime} суток',
                              style: AppStyles.p1,
                            ),
                          ],
                        ),
                      ),
                      Image.network(
                        currentProduct.image,
                        height: 100,
                        width: 100,
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          StreamedStateBuilder<LensDateModel?>(
            streamedState: myLensesWM.leftLensDate,
            builder: (_, leftPutDate) => StreamedStateBuilder<LensDateModel?>(
              streamedState: myLensesWM.rightLensDate,
              builder: (_, rightPutDate) => leftPutDate != null &&
                      rightPutDate != null
                  ? const SizedBox.shrink()
                  : leftPutDate != null
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 20,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GreyButton(
                                  text: 'Надеть правую линзу',
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  onPressed: () async =>
                                      showModalBottomSheet<num>(
                                    isScrollControlled: true,
                                    context: context,
                                    barrierColor: Colors.black.withOpacity(0.8),
                                    builder: (context) {
                                      return PutOnDateSheet(
                                        onConfirmed: ({leftDate, rightDate}) =>
                                            myLensesWM.putOnLenses(
                                          leftDate: leftDate,
                                          rightDate: rightDate,
                                        ),
                                        rightPut: DateTime.now(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : rightPutDate != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GreyButton(
                                      text: 'Надеть левую линзу',
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      onPressed: () async =>
                                          showModalBottomSheet<num>(
                                        isScrollControlled: true,
                                        context: context,
                                        barrierColor:
                                            Colors.black.withOpacity(0.8),
                                        builder: (context) {
                                          return PutOnDateSheet(
                                            onConfirmed: ({
                                              leftDate,
                                              rightDate,
                                            }) =>
                                                myLensesWM.putOnLenses(
                                              leftDate: leftDate,
                                              rightDate: rightDate,
                                            ),
                                            leftPut: DateTime.now(),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GreyButton(
                                      text: 'Изменить',
                                      onPressed: () async => Keys
                                          .mainContentNav.currentState!
                                          .pushNamed(
                                        '/choose_lenses',
                                        arguments: [
                                          true,
                                          myLensesWM.lensesPairModel.value,
                                        ],
                                      ).then((value) {
                                        myLensesWM.loadAllData();
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  Expanded(
                                    child: BlueButtonWithText(
                                      text: 'Надеть',
                                      onPressed: () async =>
                                          showModalBottomSheet<num>(
                                        isScrollControlled: true,
                                        context: context,
                                        barrierColor:
                                            Colors.black.withOpacity(0.8),
                                        builder: (context) {
                                          return PutOnDateSheet(
                                            onConfirmed: ({
                                              leftDate,
                                              rightDate,
                                            }) =>
                                                myLensesWM.putOnLenses(
                                              leftDate: leftDate,
                                              rightDate: rightDate,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
            ),
          ),
        ],
      ),
    );
  }
}
