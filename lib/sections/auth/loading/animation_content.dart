import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

class AnimationContent extends StatelessWidget {
  const AnimationContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      'Пользуйтесь продукцией Bausch+Lomb и получайте любимые товары и другие привилегии',
                      style: TextStyle(
                        fontSize: 24, // 24.sm,
                        height: 31 / 24,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Региструйте коды с упаковки,\nкопите баллы и тратьте их ',
                      style: AppStyles.p1Grey,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: BlueButtonWithText(
              text: 'Войти по номеру телефона',
              onPressed: () {
                Keys.mainContentNav.currentState!.pushNamed('/registration');
              },
            ),
          ),
        ],
      ),
    );
  }
}
