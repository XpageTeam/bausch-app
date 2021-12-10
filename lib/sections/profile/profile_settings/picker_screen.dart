import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerScreen extends StatefulWidget {
  final String title;
  const PickerScreen({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  int selectedItem = 0;

  List<String> numbers = [
    '-8',
    '-7',
    '-6',
    '-5',
    '-4',
    '-3',
    '-2',
    '-1',
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: StaticData.sidePadding,
            left: StaticData.sidePadding,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.mineShaft,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              //TODO(Nikita): не забыть при слиянии
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Диоптрий',
                  style: AppStyles.h1,
                ),
              ),
              //TODO(Nikita): Придумать что-то с оверлеем, чтобы не выглядело так стремно при переходе
              Flexible(
                //height: 300,
                child: CupertinoPicker.builder(
                  childCount: numbers.length,
                  itemExtent: 40,
                  onSelectedItemChanged: (i) {
                    setState(() {
                      selectedItem = i;
                    });
                  },
                  selectionOverlay: null,
                  itemBuilder: (context, i) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 130,
                      ),
                      decoration: BoxDecoration(
                        color: selectedItem == i
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            numbers[i],
                            style: AppStyles.h2,
                          ),
                          Text(
                            '${int.parse(numbers[i]) * 25}',
                            style: AppStyles.h2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 26,
                ),
                child: BlueButtonWithText(
                  text: 'Добавить',
                  onPressed: () {
                    Navigator.of(context).pop(int.parse(numbers[selectedItem]));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
