import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PickerScreen extends StatefulWidget {
  const PickerScreen({Key? key}) : super(key: key);

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  int selectedItem = 0;

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
              const Text(
                'Диоптрий',
                style: AppStyles.h1,
              ),
              //TODO(Nikita): Придумать что-то с оверлеем, чтобы не выглядело так стремно при переходе
              Flexible(
                //height: 300,
                child: CupertinoPicker.builder(
                  childCount: 10,
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
                            '+${i + 1}',
                            style: AppStyles.h2,
                          ),
                          Text(
                            '${i * 25}',
                            style: AppStyles.h2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const BlueButtonWithText(text: 'Добавить'),
            ],
          ),
        ),
      ),
    );
  }
}
