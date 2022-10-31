import 'package:bausch/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class PutOnDateSheet extends StatefulWidget {
  final void Function({DateTime? rightDate, DateTime? leftDate}) onConfirmed;
  final DateTime? leftPut;
  final DateTime? rightPut;
  const PutOnDateSheet({
    required this.onConfirmed,
    required this.leftPut,
    required this.rightPut,
    Key? key,
  }) : super(key: key);

  @override
  State<PutOnDateSheet> createState() => _PutOnDateSheetState();
}

class _PutOnDateSheetState extends State<PutOnDateSheet> {
  bool leftActive = true;

  DateTime? date;

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 30),
                    child: Text(
                      widget.leftPut != null && widget.rightPut != null
                          ? 'Когда надеты линзы'
                          : widget.rightPut != null
                              ? 'Правая линза надета'
                              : 'Левая линза надета',
                      style: AppStyles.h1,
                    ),
                  ),
                  GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        'Отменить',
                        style: AppStyles.h3,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                clipBehavior: Clip.hardEdge,
                child: DatePickerWidget(
                  onMonthChangeStartWithFirstDate: false,
                  initialDateTime: widget.leftPut ?? widget.rightPut,
                  minDateTime: DateTime(DateTime.now().year - 1),
                  maxDateTime: DateTime.now().add(const Duration(days: 5)),
                  locale: DateTimePickerLocale.ru,
                  // onCancel: () {},
                  dateFormat: 'dd.MM.yyyy',
                  pickerTheme: const DateTimePickerTheme(
                    cancel: SizedBox(),
                    confirm: SizedBox(),
                    titleHeight: 0,
                  ),
                  onChange: (dateTime, _) => setState(() {
                    date = dateTime;
                  }),
                  onConfirm: (date, i) {
                    widget.onConfirmed(
                      leftDate: widget.leftPut != null ? date : null,
                      rightDate: widget.rightPut != null ? date : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              BlueButton(
                children: const [
                  Text(
                    'Выбрать',
                    style: AppStyles.h2,
                  ),
                ],
                onPressed: () {
                  widget.onConfirmed(
                    leftDate: widget.leftPut != null ? date : null,
                    rightDate: widget.rightPut != null ? date : null,
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
