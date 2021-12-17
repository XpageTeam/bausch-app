import 'package:bausch/sections/auth/loading/widget_conveyor.dart';
import 'package:bausch/widgets/animated_reverse_opacity.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColumnWithDynamicDuration extends StatelessWidget {
  final List<Widget> children;
  const ColumnWithDynamicDuration({required this.children, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spaceBetween = (MediaQuery.of(context).size.width - 114.sp * 2) / 3;

    return IgnorePointer(
      child: ListView.separated(
        //shrinkWrap: true,
        itemBuilder: (context, i) {
          if (i == 1) {
            return DelayedAnimatedTranslateOpacity(
              offsetY: 20,
              //animationDuration: const Duration(milliseconds: 800),
              delay: Duration(milliseconds: 200 + i * 400),
              child: WidgetConveyor(
                children: [
                  SizedBox(
                    width: spaceBetween,
                  ),
                  IntrinsicWidth(child: children[1]),
                  SizedBox(
                    width: spaceBetween,
                  ),
                  IntrinsicWidth(child: children[2]),
                  SizedBox(
                    width: spaceBetween,
                  ),
                  IntrinsicWidth(child: children[3]),
                  SizedBox(
                    width: spaceBetween,
                  ),
                  IntrinsicWidth(child: children[1]),
                  SizedBox(
                    width: spaceBetween,
                  ),
                ],
              ),
            );
          } else if (i == 0) {
            return DelayedAnimatedTranslateOpacity(
              offsetY: 0,
              //animationDuration: const Duration(milliseconds: 600),
              child: children[i],
              delay: Duration(milliseconds: 200 + i * 400),
            );
          } else {
            return AnimatedReverseOpacity(
              offsetY: 20,
              //animationDuration: const Duration(milliseconds: 600),
              child: children[i],
              delay: Duration(milliseconds: 200 + i * 400),
            );
          }
        },
        separatorBuilder: (context, i) {
          return SizedBox(
            height: i == 0 ? 80.sp : spaceBetween,
          );
        },
        itemCount: children.length,
      ),
    );
  }
}
