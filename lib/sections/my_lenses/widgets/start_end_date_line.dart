import 'package:bausch/help/help_functions.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class StartEndDateLine extends StatelessWidget {
  final MyLensesWM myLensesWM;
  final bool hasIcon;
  final bool isLeft;
  const StartEndDateLine({
    required this.myLensesWM,
    this.isLeft = true,
    this.hasIcon = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasIcon)
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 17,
                  width: 17,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLeft ? AppTheme.turquoiseBlue : AppTheme.sulu,
                  ),
                  child: Center(
                    child: Text(isLeft ? 'L' : 'R', style: AppStyles.n1),
                  ),
                ),
              ),
            if (hasIcon) const SizedBox(width: 6),
            Text(
              HelpFunctions.formatDateRu(
                date: isLeft
                    ? myLensesWM.leftLensDate.value!.dateStart
                    : myLensesWM.rightLensDate.value!.dateStart,
              ),
              style: AppStyles.p1,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 6,
            right: 2,
          ),
          child: Image.asset(
            (isLeft
                        ? myLensesWM.leftLensDate.value!.daysLeft
                        : myLensesWM.rightLensDate.value!.daysLeft) <
                    0
                ? 'assets/short_line_dots.png'
                : 'assets/line_dots.png',
            scale: hasIcon ? 7 : 4.8,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_none,
              size: 18,
            ),
            Text(
              HelpFunctions.formatDateRu(
                date: isLeft
                    ? myLensesWM.leftLensDate.value!.dateEnd
                    : myLensesWM.rightLensDate.value!.dateEnd,
                haveWeekDay: true,
              ),
              style: AppStyles.p1,
            ),
            if ((isLeft
                    ? myLensesWM.leftLensDate.value!.daysLeft
                    : myLensesWM.rightLensDate.value!.daysLeft) <
                0)
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  '${isLeft ? myLensesWM.leftLensDate.value!.daysLeft.toString().replaceFirst('-', '+ ') : myLensesWM.rightLensDate.value!.daysLeft.toString().replaceFirst('-', '+ ')} д',
                  style: AppStyles.p1.copyWith(color: Colors.redAccent),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
