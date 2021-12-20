import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Виджет круглого значка баллов
/// (такой assets/points.png)
class PointWidget extends StatelessWidget {
  final double radius;
  final TextStyle textStyle;
  const PointWidget({
    required this.textStyle,
    this.radius = 14,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppTheme.turquoiseBlue,
      radius: radius,
      child: Text(
        'б',
        style: textStyle,
      ),
    );
  }
}
