import 'package:bausch/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class DifferentLensesSheet extends StatefulWidget {
  final VoidCallback onConfirmed;
  const DifferentLensesSheet({
    required this.onConfirmed,
    Key? key,
  }) : super(key: key);

  @override
  State<DifferentLensesSheet> createState() => _DifferentLensesSheetState();
}

class _DifferentLensesSheetState extends State<DifferentLensesSheet> {
  bool leftActive = true;
  DateTime leftDate = DateTime.now();
  DateTime rightDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ColoredBox(
        color: AppTheme.mystic,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
            bottom: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.mineShaft,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 30),
                child: Text(
                  'Линзы надеты',
                  style: AppStyles.h1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['L', 'R']
                    .map(
                      (type) => Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: 'L' == type && leftActive ||
                                      'R' == type && !leftActive
                                  ? AppTheme.turquoiseBlue
                                  : Colors.white,
                              width: 2,
                            ),
                            color: Colors.white,
                          ),
                          child: InkWell(
                            splashFactory: NoSplash.splashFactory,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              setState(() {
                                leftActive = !leftActive;
                              });
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 11, top: 9),
                                child: Text(
                                  type,
                                  style: AppStyles.h2Bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 10),
              if (leftActive)
                DatePickerWidget(
                  key: const Key('first'),
                  onMonthChangeStartWithFirstDate: false,
                  initialDateTime: leftDate,
                  minDateTime: DateTime(2021),
                  maxDateTime: DateTime.now(),
                  locale: DateTimePickerLocale.ru,
                  onCancel: () {},
                  onChange: (value, _) {
                    debugPrint('left');
                    leftDate = value;
                  },
                  dateFormat: 'dd.MM.yyyy',
                  // TODO(pavlov): в каждом конфирме нужно подтверждать и левую и правую
                  onConfirm: (date, i) {
                    widget.onConfirmed();
                    debugPrint('left');
                  },
                )
              else
                DatePickerWidget(
                  key: const Key('second'),
                  onMonthChangeStartWithFirstDate: false,
                  initialDateTime: rightDate,
                  minDateTime: DateTime(2021),
                  maxDateTime: DateTime.now(),
                  locale: DateTimePickerLocale.ru,
                  onCancel: () {},
                  onChange: (value, _) {
                    rightDate = value;
                  },
                  dateFormat: 'dd.MM.yyyy',
                  onConfirm: (date, i) {
                    widget.onConfirmed();
                    debugPrint('right');
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
