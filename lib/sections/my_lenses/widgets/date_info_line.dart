import 'package:bausch/help/help_functions.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class DateInfoLine extends StatelessWidget {
  final MyLensesWM myLensesWM;
  final bool hasIcon;
  final bool isLeft;
  const DateInfoLine({
    required this.myLensesWM,
    this.isLeft = true,
    this.hasIcon = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actualDateStart = isLeft
        ? myLensesWM.leftLensDate.value!.dateStart
        : myLensesWM.rightLensDate.value!.dateStart;
    final actualDateEnd = isLeft
        ? myLensesWM.leftLensDate.value!.dateEnd
        : myLensesWM.rightLensDate.value!.dateEnd;
    final actualDaysLeft = isLeft
        ? myLensesWM.leftLensDate.value!.daysLeft
        : myLensesWM.rightLensDate.value!.daysLeft;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Center(
            child: DottedLine(
              lineLength: MediaQuery.of(context).size.width / 1.5,
              dashColor: AppTheme.grey,
              dashLength: 2,
              dashGapLength: 2,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            WhiteContainerWithRoundedCorners(
              child: Row(
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
                          color:
                              isLeft ? AppTheme.turquoiseBlue : AppTheme.sulu,
                        ),
                        child: Center(
                          child: Text(isLeft ? 'L' : 'R', style: AppStyles.n1),
                        ),
                      ),
                    ),
                  if (hasIcon) const SizedBox(width: 6),
                  Text(
                    '${actualDateStart.day} ${HelpFunctions.getMonthNameByNumber(actualDateStart.month)}, ${actualDateStart.hour < 10 ? 0 : ''}${actualDateStart.hour}:${actualDateStart.minute < 10 ? 0 : ''}${actualDateStart.minute}',
                    style: AppStyles.p1,
                  ),
                  Container(width: 8, height: 10, color: Colors.white),
                ],
              ),
            ),
            WhiteContainerWithRoundedCorners(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 8, height: 10, color: Colors.white),
                  const Icon(
                    Icons.notifications_none,
                    size: 18,
                  ),
                  Text(
                    '${HelpFunctions.weekday(actualDateEnd.day)}, ${actualDateEnd.day} ${HelpFunctions.getMonthNameByNumber(actualDateEnd.month)}, ${actualDateEnd.hour < 10 ? 0 : ''}${actualDateEnd.hour}:${actualDateEnd.minute < 10 ? 0 : ''}${actualDateEnd.minute}',
                    style: AppStyles.p1,
                  ),
                  if (actualDaysLeft < 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        '${actualDaysLeft.toString().replaceFirst('-', '+ ')} д',
                        style: AppStyles.p1.copyWith(color: Colors.redAccent),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
