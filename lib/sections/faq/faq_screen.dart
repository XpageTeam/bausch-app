import 'package:bausch/sections/faq/social_buttons.dart';
import 'package:bausch/sections/sheets/screens/webinars/dialog_with_players.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  final ScrollController controller;
  const FaqScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DefaultAppBar(
                          title: 'Частые вопросы',
                          backgroundColor: AppTheme.mystic,
                          topRightWidget: NormalIconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              Keys.mainNav.currentState!.pop();
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            right: StaticData.sidePadding,
                            left: StaticData.sidePadding,
                            top: 30,
                          ),
                          child: Text(
                            'Темы',
                            style: AppStyles.h2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 4,
                    ),
                    child: WhiteButton(
                      text: 'Очки и контактные линзы',
                      icon: Container(),
                      onPressed: () {
                        Keys.simpleBottomSheetNav.currentState!
                            .pushNamed('/faq');
                      },
                    ),
                  ),
                  childCount: 8,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SliverList(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
