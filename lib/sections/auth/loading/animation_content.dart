import 'package:bausch/sections/registration/registration_screen.dart';
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 20),
                child: Text(
                  'Пользуйтесь продукцией Bauch+lomb и получайте любимые товары и другие привилегии',
                  style: AppStyles.h1,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                'Региструйте коды с упаковки, копите былла и тратье их ',
                style: AppStyles.p1Grey,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            children: [
              BlueButtonWithText(
                text: 'Войти по номеру телефона',
                onPressed: () {
                  //* Потом поменяю на pushNamed
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return const RegistrationScreen();
                      },
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
