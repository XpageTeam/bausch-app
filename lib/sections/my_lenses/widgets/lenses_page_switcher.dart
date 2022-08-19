import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class LensesPageSwitcher extends StatelessWidget {
  final MyLensesWM myLensesWM;
  const LensesPageSwitcher({required this.myLensesWM, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: MyLensesPage.values
          .map(
            (type) => StreamedStateBuilder<MyLensesPage>(
              streamedState: myLensesWM.currentPageStreamed,
              builder: (_, currentType) => Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: currentType == type
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
                    onTap: () async {
                      await myLensesWM.currentPageStreamed.accept(
                        currentType == MyLensesPage.currentLenses
                            ? MyLensesPage.oldLenses
                            : MyLensesPage.currentLenses,
                      );
                    },
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 11, top: 9),
                        child: Text(
                          type.asString,
                          style: AppStyles.h2Bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
