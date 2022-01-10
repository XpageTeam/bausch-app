import 'package:bausch/sections/auth/loading/widget_conveyor.dart';
import 'package:bausch/widgets/animated_reverse_opacity.dart';
import 'package:bausch/widgets/animated_translate_opacity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColumnWithDynamicDuration extends StatefulWidget {
  final List<Widget> children;
  final ValueChanged<double> onHeightChanged;
  const ColumnWithDynamicDuration({
    required this.children,
    required this.onHeightChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<ColumnWithDynamicDuration> createState() =>
      _ColumnWithDynamicDurationState();
}

class _ColumnWithDynamicDurationState extends State<ColumnWithDynamicDuration> {
  final globalKey = GlobalKey();
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance!.addPostFrameCallback(
  //     (_) => widget.onHeightChanged(
  //       globalKey.currentContext!.size!.height,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final spaceBetween = (MediaQuery.of(context).size.width - 114.sp * 2) / 3;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DelayedAnimatedTranslateOpacity(
          offsetY: 0,
          child: LayoutBuilder(builder: (context, constraints) {
            widget.onHeightChanged(constraints.minHeight);
            return widget.children[0];
          }),
        ),
        Expanded(
          child: IgnorePointer(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, i) {
                final j = i;

                if (j == 0) {
                  return const SizedBox();
                }

                if (j == 1) {
                  return DelayedAnimatedTranslateOpacity(
                    offsetY: 20,
                    //animationDuration: const Duration(milliseconds: 800),
                    delay: Duration(milliseconds: 200 + j * 400),
                    child: WidgetConveyor(
                      children: [
                        SizedBox(
                          width: spaceBetween,
                        ),
                        IntrinsicWidth(child: widget.children[1]),
                        SizedBox(
                          width: spaceBetween,
                        ),
                        IntrinsicWidth(child: widget.children[2]),
                        SizedBox(
                          width: spaceBetween,
                        ),
                        IntrinsicWidth(child: widget.children[3]),
                        SizedBox(
                          width: spaceBetween,
                        ),
                        IntrinsicWidth(child: widget.children[1]),
                        SizedBox(
                          width: spaceBetween,
                        ),
                      ],
                    ),
                  );
                } else {
                  return AnimatedReverseOpacity(
                    offsetY: 20,
                    //animationDuration: const Duration(milliseconds: 600),
                    child: widget.children[j],
                    delay: Duration(milliseconds: 200 + j * 400),
                  );
                }
              },
              separatorBuilder: (context, i) {
                return SizedBox(
                  height: spaceBetween,
                );
              },
              itemCount: widget.children.length,
            ),
          ),
        ),
      ],
    );
  }
}
