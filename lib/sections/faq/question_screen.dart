import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  final ScrollController controller;
  const QuestionScreen({required this.controller, Key? key}) : super(key: key);

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
                  DefaultAppBar(
                    title: 'Частые вопросы',
                    backgroundColor: AppTheme.mystic,
                    topRightWidget: NormalIconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Keys.mainNav.currentState!.pop();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 12,
                      left: 12,
                      top: 31,
                      bottom: 100,
                    ),
                    child: Column(
                      children: const [
                        Text(
                          'Почему в контактных линзах видно лучше, чем в очках?',
                          style: AppStyles.h2,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          'Контактные линзы находятся непосредственно на роговице, поэтому они не ограничивают поле зрения и не дают дополнительных искажений, в отличие от очков. Некоторые контактные линзы имеют асферическую оптику, которая помогает обеспечить более высокое качество зрения. Bausch+Lomb использует асферическую оптику в контактных линзах Biotrue® ONEday*, PureVision®2 и Bausch+Lomb ULTRA**, что помогает обеспечить более четкое зрение при длительной работе за компьютером, при длительной работе с цифровыми устройствами, в условиях сухого воздуха, при вождении автомобиля ночью.48 Имеются противопоказания, перед применением необходимо проконсультироваться со специалистом.',
                          style: AppStyles.p1,
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: StaticData.sidePadding),
              sliver: SupportSection(),
            ),
          ],
        ),
      ),
    );
  }
}
