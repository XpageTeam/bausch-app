import 'package:bausch/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class PutOnDateSheet extends StatefulWidget {
  final VoidCallback onConfirmed;
  final bool lenseLost;
  const PutOnDateSheet({
    required this.onConfirmed,
    this.lenseLost = false,
    Key? key,
  }) : super(key: key);

  @override
  State<PutOnDateSheet> createState() => _PutOnDateSheetState();
}

class _PutOnDateSheetState extends State<PutOnDateSheet> {
  bool leftActive = true;
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
                  'Напомнить о замене',
                  style: AppStyles.h1,
                ),
              ),
              if (widget.lenseLost)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LenseCircle(
                        title: 'L',
                        onTap: () {
                          setState(() {
                            leftActive = true;
                          });
                        },
                        isActive: leftActive,
                      ),
                      const SizedBox(width: 20),
                      _LenseCircle(
                        title: 'R',
                        onTap: () {
                          setState(() {
                            leftActive = false;
                          });
                        },
                        isActive: !leftActive,
                      ),
                    ],
                  ),
                ),
              DatePickerWidget(
                onMonthChangeStartWithFirstDate: false,
                initialDateTime: DateTime.now(),
                minDateTime: DateTime(2021),
                maxDateTime: DateTime.now(),
                locale: DateTimePickerLocale.ru,
                onCancel: () {},
                dateFormat: 'dd.MM.yyyy',
                onConfirm: (date, i) {
                  widget.onConfirmed();
                  debugPrint('onConfirmed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LenseCircle extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool isActive;
  const _LenseCircle({
    required this.onTap,
    required this.title,
    required this.isActive,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? AppTheme.turquoiseBlue : AppTheme.mystic,
            width: 2,
          ),
          color: Colors.white,
        ),
        child: Center(child: Text(title, style: AppStyles.h2)),
      ),
    );
  }
}
