import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomButtonWithRoundedCorners extends StatelessWidget {
  const BottomButtonWithRoundedCorners({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              color: AppTheme.mystic,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: StaticData.sidePadding,
                  right: StaticData.sidePadding,
                  top: StaticData.sidePadding + 8,
                ),
                child: BlueButtonWithText(
                  text: 'На главную',
                  onPressed: () {
                    Utils.bottomSheetNav.currentState!
                        .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                  },
                ),
              ),
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
        ),
        const InfoBlock(),
      ],
    );
  }
}
