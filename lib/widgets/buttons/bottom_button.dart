import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/floatingactionbutton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomButtonWithRoundedCorners extends StatelessWidget {
  final String text;
  final bool withInfo;
  final VoidCallback? onPressed;

  const BottomButtonWithRoundedCorners({
    this.text = 'На главную',
    this.withInfo = true,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        CustomFloatingActionButton(
          text: text,
          topPadding: 20,
          withInfo: withInfo,
          onPressed: onPressed ??
              () {
                Keys.mainContentNav.currentState!
                    .popUntil((route) => route.isFirst);
                Keys.mainNav.currentState!.popUntil((route) => route.isFirst);
              },
        ),
        Container(
          height: 8,
          decoration: const BoxDecoration(
            color: AppTheme.sulu,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ),
        ),
      ],
    );
  }
}
