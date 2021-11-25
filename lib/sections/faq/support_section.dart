import 'package:bausch/sections/faq/social_buttons/social_buttons.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

//* Нижний блок с кнопкой "Написать в поддержку" и кнопками соц сетей
class SupportSection extends StatelessWidget {
  const SupportSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 40,
            ),
            child: Text(
              'Если есть вопросы, напишите нам, мы вам поможем. Если вы нашли ошибку в приложении, сообщите нам об этом, мы всё исправим.',
              style: AppStyles.p1Grey,
            ),
          ),
          BlueButtonWithText(
            text: 'Написать в поддержку',
            onPressed: () {
              Keys.simpleBottomSheetNav.currentState!.pushNamed('/support');
            },
          ),
          const Center(
            child: SocialButtons(),
          ),
          const SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }
}
