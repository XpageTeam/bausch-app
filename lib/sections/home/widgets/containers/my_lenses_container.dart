import 'package:bausch/help/help_functions.dart';
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

// TODO(pavlov): этому контейнеру надо загрузку поставить
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
                  bottom: 24,
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
                                      Text(
                                        HelpFunctions.pairs(
                                          int.parse(currentProduct.count),
                                        ),
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
                        const SizedBox(width: 46),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: myLensesWM.lensesPairModel.value == null ||
                                  currentProduct!.lifeTime == 1
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: Image.asset(
                                    'assets/my_lenses.png',
                                    height: 57,
                                    width: 54,
                                    fit: BoxFit.scaleDown,
                                  ),
                                )
                              : leftLensDate != null && rightLensDate != null
                                  ? leftLensDate.dateEnd !=
                                          rightLensDate.dateEnd
                                      ? LensesSmallIndicator(
                                          myLensesWM: myLensesWM,
                                        )
                                      : LensSmallIndicator(
                                          myLensesWM: myLensesWM,
                                          sameTime: true,
                                        )
                                  : leftLensDate != null &&
                                              rightLensDate == null ||
                                          rightLensDate != null &&
                                              leftLensDate == null
                                      ? LensSmallIndicator(
                                          myLensesWM: myLensesWM,
                                          sameTime: false,
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
                        myLensesWM.lensesPairModel.value!.product!.lifeTime > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 24, right: 12),
                        child: Row(
                          children: [
                            if (leftLensDate != null || rightLensDate != null)
                              Expanded(
                                child: GreyButton(
                                  text: leftLensDate != null &&
                                          rightLensDate != null
                                      ? 'Завершить ношение'
                                      : 'Завершить',
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: StaticData.sidePadding,
                                  ),
                                  onPressed: () async =>
                                      myLensesWM.putOffLensesSheet(
                                    context: context,
                                  ),
                                ),
                              ),
                            if ((leftLensDate != null &&
                                    rightLensDate == null) ||
                                (leftLensDate == null && rightLensDate != null))
                              const SizedBox(width: 10),
                            if (leftLensDate == null || rightLensDate == null)
                              Expanded(
                                child: GreyButton(
                                  text: 'Надеть',
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: StaticData.sidePadding,
                                  ),
                                  onPressed: () async =>
                                      showModalBottomSheet<num>(
                                    isScrollControlled: true,
                                    context: context,
                                    barrierColor: Colors.black.withOpacity(0.8),
                                    builder: (context) {
                                      return PutOnDateSheet(
                                        leftPut: leftLensDate?.dateStart != null
                                            ? null
                                            : DateTime.now(),
                                        rightPut:
                                            rightLensDate?.dateStart != null
                                                ? null
                                                : DateTime.now(),
                                        onConfirmed: ({
                                          leftDate,
                                          rightDate,
                                        }) =>
                                            myLensesWM.putOnLensesPair(
                                          leftDate: leftLensDate?.dateStart ??
                                              leftDate,
                                          rightDate: rightLensDate?.dateStart ??
                                              rightDate,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                          ],
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
