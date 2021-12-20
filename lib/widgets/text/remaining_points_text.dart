import 'package:bausch/help/help_functions.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class RemainingPointsText extends StatelessWidget {
  final int remains;
  const RemainingPointsText({
    required this.remains,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'После заказа у вас останется ${remains.formatString} ${HelpFunctions.wordByCount(
        remains,
        [
          'баллов',
          'балл',
          'балла',
        ],
      )}',
      style: AppStyles.p1,
    );
  }
}
