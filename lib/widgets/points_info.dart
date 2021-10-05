import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class PointsInfo extends StatelessWidget {
  final String text;
  final Color? backgoundColor;
  const PointsInfo({required this.text, this.backgoundColor, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Row(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(left: 10, right: 20, top: 4, bottom: 4),
                    height: 28,
                    decoration: BoxDecoration(
                        color: backgoundColor ?? AppTheme.sulu,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      text,
                      style: AppStyles.h3,
                    ),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  const CircleAvatar(
                    child: Text(
                      'б',
                      style: TextStyle(
                          color: AppTheme.mineShaft,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          height: 20 / 17),
                    ),
                    radius: 14,
                    backgroundColor: AppTheme.turquoiseBlue,
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
