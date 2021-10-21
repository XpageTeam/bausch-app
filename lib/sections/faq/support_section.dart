import 'package:bausch/sections/faq/social_buttons.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:flutter/material.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Padding(
            padding: EdgeInsets.only(
              top: 8,
              bottom: 40,
            ),
            child: Text(
              'Если есть вопросы, напишите нам, мы вам поможем. Если вы нашли ошибку в приложении, сообщите нам об этом, мы всё исправим.',
              style: AppStyles.p1Grey,
            ),
          ),
          const BlueButtonWithText(text: 'Написать в поддержку'),
          const Padding(
            padding: EdgeInsets.only(
              top: 40,
              bottom: 14,
            ),
            child: Text(
              'Вы можете найти нас здесь',
              style: AppStyles.p1,
              textAlign: TextAlign.center,
            ),
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
