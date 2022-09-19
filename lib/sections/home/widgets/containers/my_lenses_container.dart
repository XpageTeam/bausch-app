import 'package:bausch/models/my_lenses/lens_product_list_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_dates_model.dart';
import 'package:bausch/models/my_lenses/lenses_pair_model.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/home/widgets/lenses_indicator/lens_small_indicator.dart';
import 'package:bausch/sections/home/widgets/lenses_indicator/lenses_small_indicator.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/my_lenses/widgets/sheets/put_on_date_sheet.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class MyLensesContainer extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const MyLensesContainer({required this.myLensesWM, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamedStateBuilder<LensesPairModel?>(
      streamedState: myLensesWM.lensesPairModel,
      builder: (_, lensesPairModel) => StreamedStateBuilder<LensProductModel?>(
        streamedState: myLensesWM.currentProduct,
        builder: (_, currentProduct) => StreamedStateBuilder<LensDateModel?>(
          streamedState: myLensesWM.leftLensDate,
          builder: (_, leftLensDate) => StreamedStateBuilder<LensDateModel?>(
            streamedState: myLensesWM.rightLensDate,
            builder: (_, rightLensDate) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              child: WhiteContainerWithRoundedCorners(
                onTap: () {
                  if (myLensesWM.lensesPairModel.value != null) {
                    Keys.mainContentNav.currentState!
                        .pushNamed('/my_lenses', arguments: [myLensesWM]);
                  } else {
                    Keys.mainContentNav.currentState!
                        .pushNamed('/choose_lenses', arguments: [false]);
                  }
                },
                padding: const EdgeInsets.only(
                  left: StaticData.sidePadding,
                  bottom: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Мои линзы',
                                style: AppStyles.h1,
                              ),
                              if (myLensesWM.lensesPairModel.value != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentProduct!.name,
                                        style: AppStyles.p1,
                                      ),
                                      Text(
                                        currentProduct.lifeTime > 1
                                            ? 'Плановой замены'
                                            : 'Однодневные',
                                        style: AppStyles.p1,
                                      ),
                                      if (currentProduct.lifeTime > 1)
                                        Text(
                                          'До ${currentProduct.lifeTime} суток',
                                          style: AppStyles.p1,
                                        ),
                                    ],
                                  ),
                                )
                              else
                                const Text(
                                  'История ношения, сроки замены и параметры линз всегда под рукой',
                                  style: AppStyles.p1,
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: myLensesWM.lensesPairModel.value == null ||
                                  currentProduct!.lifeTime == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Image.asset(
                                    'assets/my_lenses.png',
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.scaleDown,
                                  ),
                                )
                              : leftLensDate != null && rightLensDate != null
                                  // TODO(info): судя по макетам сравниваем по оставшимся дням
                                  ? leftLensDate.dateEnd !=
                                          rightLensDate.dateEnd
                                      ? LensesSmallIndicator(
                                          myLensesWM: myLensesWM,
                                        )
                                      : LensSmallIndicator(
                                          myLensesWM: myLensesWM,
                                        )
                                  : leftLensDate != null &&
                                              rightLensDate == null ||
                                          rightLensDate != null &&
                                              leftLensDate == null
                                      ? LensSmallIndicator(
                                          myLensesWM: myLensesWM,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20.0,
                                          ),
                                          child: Image.asset(
                                            'assets/my_lenses.png',
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                        ),
                      ],
                    ),
                    if (myLensesWM.lensesPairModel.value != null &&
                        currentProduct!.lifeTime > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 24, right: 12),
                        child: GreyButton(
                          text: leftLensDate != null || rightLensDate != null
                              ? 'Завершить ношение'
                              : 'Надеть',
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: StaticData.sidePadding,
                          ),
                          onPressed: () async {
                            if (leftLensDate != null || rightLensDate != null) {
                              await myLensesWM.putOffLenses(context: context);
                            } else {
                              await showModalBottomSheet<num>(
                                isScrollControlled: true,
                                context: context,
                                barrierColor: Colors.black.withOpacity(0.8),
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
                              );
                            }
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
