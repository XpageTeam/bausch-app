import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SinglePickerScreen extends StatefulWidget {
  final String title;
  final List<String> variants;
  const SinglePickerScreen({
    required this.title,
    required this.variants,
    Key? key,
  }) : super(key: key);

  @override
  State<SinglePickerScreen> createState() => _SinglePickerScreenState();
}

class _SinglePickerScreenState extends State<SinglePickerScreen> {
  int selectedNumber = 0;
  //int selectedHundred = 0;

  // List<String> variants = [
  //   '-8',
  //   '-7',
  //   '-6',
  //   '-5',
  //   '-4',
  //   '-3',
  //   '-2',
  //   '-1',
  //   '0',
  //   '+1',
  //   '+2',
  //   '+3',
  //   '+4',
  //   '+5',
  //   '+6',
  //   '+7',
  //   '+8',
  // ];

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
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: AppStyles.h1,
                ),
              ),
              Flexible(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    CupertinoPicker.builder(
                      childCount: widget.variants.length,
                      itemExtent: 40,
                      //offAxisFraction: -0.5,
                      onSelectedItemChanged: (i) {
                        setState(() {
                          selectedNumber = i;
                        });
                      },
                      selectionOverlay: null,
                      itemBuilder: (context, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.variants[i],
                              style: AppStyles.h2,
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 26,
                ),
                child: BlueButtonWithText(
                  text: '????????????????',
                  onPressed: () {
                    Navigator.of(context).pop(widget.variants[selectedNumber]);
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
