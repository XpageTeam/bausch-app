import 'package:bausch/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ReplacementDayIndicator extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const ReplacementDayIndicator({required this.myLensesWM, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: WhiteContainerWithRoundedCorners(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: StaticData.sidePadding,
        ),
        child: StreamedStateBuilder<String>(
          streamedState: myLensesWM.replacementDay,
          builder: (_, replacementDay) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 30,
                ),
                child: replacementDay == 'Нет'
                    ? CircularPercentIndicator(
                        header: const Padding(
                          padding: EdgeInsets.only(
                            bottom: 20,
                          ),
                          child: Text(
                            'Дней до замены',
                            style: AppStyles.h2,
                          ),
                        ),
                        radius: 85,
                        animation: true,
                        animationDuration: 2000,
                        lineWidth: 15.0,
                        percent: 0.75,
                        center: const Text(
                          '22',
                          style: AppStyles.h0,
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        backgroundColor: AppTheme.mystic,
                        progressColor: AppTheme.sulu,
                      )
                    : GestureDetector(
                        onTap: () async =>
                            myLensesWM.replacementDay.accept('Нет'),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: Text(
                                replacementDay == 'Да'
                                    ? 'День замены'
                                    : 'День замены просрочен',
                                style: AppStyles.h2,
                              ),
                            ),
                            Stack(alignment: Alignment.center, children: [
                              if (replacementDay == 'Да')
                                Image.asset(
                                  'assets/replacement_day.png',
                                  scale: 2.53,
                                )
                              else
                                Image.asset(
                                  'assets/replacement_day_overdue.png',
                                  scale: 2.53,
                                ),
                              const Text(
                                'Замените\nлинзы',
                                style: AppStyles.h1,
                                textAlign: TextAlign.center,
                              ),
                            ]),
                          ],
                        ),
                      ),
              ),
              Row(
                children: [
                  const Text(
                    '5 май, 16:00',
                    style: AppStyles.p1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 6,
                      right: 2,
                    ),
                    child: Image.asset(
                      replacementDay == 'Просрочен'
                          ? 'assets/short_line_dots.png'
                          : 'assets/line_dots.png',
                      scale: 3,
                    ),
                  ),
                  const Icon(
                    Icons.notifications_none,
                    size: 18,
                  ),
                  const Text(
                    'Вс, 22 сен, 16:00',
                    style: AppStyles.p1,
                  ),
                  if (replacementDay == 'Просрочен')
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        '+ 800',
                        style: AppStyles.p1.copyWith(color: Colors.red),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                ),
                child: Row(
                  children: [
                    if (replacementDay == 'Нет')
                      Expanded(
                        child: GreyButton(
                          text: 'Редактировать',
                          onPressed: () async => DatePicker.showDatePicker(
                            context,
                            initialDateTime: DateTime.now(),
                            minDateTime: DateTime(2021),
                            maxDateTime: DateTime.now(),
                            locale: DateTimePickerLocale.ru,
                            onCancel: () {},
                            dateFormat: 'dd.MM.yyyy',
                            onConfirm: (date, i) {
                              debugPrint('onchanged');
                            },
                          ),
                        ),
                      ),
                    const SizedBox(width: 3),
                    Expanded(
                      child: BlueButtonWithText(
                        text: replacementDay == 'Нет'
                            ? 'Завершить'
                            : 'Завершить ношение',
                        onPressed: () async =>
                            myLensesWM.puttedOn.accept(false),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
