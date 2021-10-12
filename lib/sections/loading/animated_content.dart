import 'package:bausch/sections/registration/registration_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AnimatedContent extends AnimatedWidget {
  const AnimatedContent({required Animation<double> animation, Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return Container(
      transform: Matrix4.translationValues(0, animation.value, 0),
      padding: const EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
      height: MediaQuery.of(context).size.height / 2,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
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
                        return RegistrationScreen();
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
