import 'package:bausch/sections/auth/loading/widget_conveyor.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:flutter/material.dart';

class ColumnWithDynamicDuration extends StatelessWidget {
  final List<Widget> children;
  const ColumnWithDynamicDuration({required this.children, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spaceBetween = (MediaQuery.of(context).size.width - 114 * 2) / 3;

    return ListView.separated(
      itemBuilder: (context, i) {
        if (i == 1) {
          return DelayedAnimatedTranslateOpacity(
            offsetY: 20,
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
        } else {
          return DelayedAnimatedTranslateOpacity(
            offsetY: 20,
            child: children[i],
            delay: Duration(milliseconds: 200 + i * 400),
          );
        }
      },
      separatorBuilder: (context, i) {
        return const SizedBox(
          height: 63,
        );
      },
      itemCount: children.length,
    );
  }
}

// return DelayedAnimatedTranslateOpacity(
//           child: i != 1
//               ? children[i]
//               : const WidgetConveyor(
//                   duration: 20,
//                   child: ImageRow(
//                     firstImg: 'assets/loading/1.png',
//                     secondImg: 'assets/loading/2.png',
//                   ),
//                 ),
//           offsetY: 20,
//           delay: Duration(milliseconds: 200 + i * 400),
//         );
