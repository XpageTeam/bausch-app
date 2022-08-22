import 'package:bausch/sections/home/sections/may_be_interesting_section.dart';
import 'package:bausch/sections/home/widgets/containers/white_container_with_rounded_corners.dart';
import 'package:bausch/sections/my_lenses/widgets/lens_description.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/blue_button_with_text.dart';
import 'package:bausch/widgets/buttons/grey_button.dart';
import 'package:flutter/material.dart';

// TODO(all): панель не поддается драгу
class ActivateLensesSheet extends StatelessWidget {
  final String title;
  final VoidCallback onActivate;
  const ActivateLensesSheet({
    required this.title,
    required this.onActivate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final historyList = ['5 май, 16:00', '6 май, 16:00', '7 май, 16:00'];
    return CustomSheetScaffold(
      controller: ScrollController(),
      resizeToAvoidBottomInset: false,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(StaticData.sidePadding),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              WhiteContainerWithRoundedCorners(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: StaticData.sidePadding,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: AppStyles.h2,
                                ),
                                const Text(
                                  'срок действия',
                                  style: AppStyles.p1,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 100,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      BlueButtonWithText(
                        text: 'Сделать активными',
                        onPressed: () {
                          Navigator.of(context).pop();
                          onActivate();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              WhiteContainerWithRoundedCorners(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: StaticData.sidePadding,
                ),
                child: Row(
                  children: const [
                    Expanded(child: LensDescription(title: 'L')),
                    Expanded(child: LensDescription(title: 'R')),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: MayBeInteresting(text: 'Рекомендуемые продукты'),
              ),
              // TODO(pavlov): в однодневках истории не будет, убрать
              const Text(
                'История ношения',
                style: AppStyles.h1,
              ),
              const SizedBox(height: 20),
              WhiteContainerWithRoundedCorners(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: StaticData.sidePadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                          child: Text(
                            'Надеты',
                            style: AppStyles.p1Grey,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Заменены',
                            style: AppStyles.p1Grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: historyList.length,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Text(
                              historyList[index],
                              style: AppStyles.p1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: Image.asset(
                                'assets/line_dots.png',
                                scale: 4.1,
                              ),
                            ),
                            Text(
                              historyList[index],
                              style: AppStyles.p1,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const GreyButton(
                      text: 'Ранее',
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: StaticData.sidePadding,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    'Имеются противопоказания, необходимо\nпроконсультироваться со специалистом',
                    style: AppStyles.p1Grey,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
