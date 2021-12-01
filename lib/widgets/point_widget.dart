import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

/// Виджет круглого значка баллов
/// (такой assets/points.png)
class PointWidget extends StatefulWidget {
  final double radius;
  final TextStyle? textStyle;
  const PointWidget({
    this.radius = 14,
    this.textStyle,
    Key? key,
  }) : super(key: key);

  @override
  State<PointWidget> createState() => _PointWidgetState();
}

class _PointWidgetState extends State<PointWidget> {
  final style = AppStyles.h2Bold;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppTheme.turquoiseBlue,
      radius: widget.radius,
      child: Text(
        'б',
        style: widget.textStyle ?? style,
      ),
    );
  }
}
