import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class WhitePickerScreen extends StatefulWidget {
  final String title;
  final List<String> variants;
  const WhitePickerScreen({
    required this.title,
    required this.variants,
    Key? key,
  }) : super(key: key);

  @override
  State<WhitePickerScreen> createState() => _WhitePickerScreenState();
}

class _WhitePickerScreenState extends State<WhitePickerScreen> {
  int selectedNumber = 0;
  DateTime selectedDate = DateTime.now();
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
                padding: const EdgeInsets.only(bottom: 20),
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 30),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.turquoiseBlue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      WhiteContainerWithRoundedCorners(
                        padding: const EdgeInsets.all(20),
                        child: DatePickerWidget(
                          locale: DateTimePickerLocale.ru,

                          lastDate: DateTime.now(),
//              initialDate: DateTime.now(),// DateTime(1994),
                          dateFormat:
                              // "MM-dd(E)",
                              "dd/MMMM/yyyy",
                          //     locale: DatePicker.localeFromString('he'),
                          onChange: (DateTime newDate, _) {
                            setState(() {
                              selectedDate = newDate;
                            });
                            print(selectedDate);
                          },

                          pickerTheme: const DateTimePickerTheme(
                            backgroundColor: Colors.white,
                            itemTextStyle: AppStyles.h2,
                            
                            dividerColor: Colors.transparent,
                          ),
                        ),
                      ),
                      // CupertinoPicker.builder(
                      //   childCount: widget.variants.length,
                      //   itemExtent: 40,
                      //   //offAxisFraction: -0.5,
                      //   onSelectedItemChanged: (i) {
                      //     setState(() {
                      //       selectedNumber = i;
                      //     });
                      //   },
                      //   selectionOverlay: null,
                      //   itemBuilder: (context, i) {
                      //     return Row(
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: [
                      //         Text(
                      //           widget.variants[i],
                      //           style: AppStyles.h2,
                      //         ),
                      //         const SizedBox(
                      //           width: 15,
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 26,
                ),
                child: BlueButtonWithText(
                  text: 'Готово',
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
