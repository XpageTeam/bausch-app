import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/buttons/text_button.dart';
import 'package:bausch/widgets/buttons/text_button_icon.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

class AddFilesScreen extends StatelessWidget {
  final ScrollController controller;
  const AddFilesScreen({required this.controller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    height: 12,
                  ),
                  DefaultAppBar(
                    title: 'Прикрепить файл',
                    backgroundColor: AppTheme.mystic,
                    topRightWidget: NormalIconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Keys.mainNav.currentState!.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                StaticData.sidePadding,
                31,
                StaticData.sidePadding,
                0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(
                            Icons.add_circle_outline_sharp,
                            size: 20,
                            color: AppTheme.mineShaft,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Прикрепить файл',
                            style: AppStyles.h2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 31,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Icon(Icons.replay_outlined),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Название файла.jpg',
                                    style: AppStyles.h2,
                                  ),
                                  Text(
                                    'Загружаем...',
                                    style: AppStyles.p1Grey,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 27),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13),
                              child: Icon(Icons.file_copy),
                            ),
                            Flexible(
                              child: Text(
                                'Название файла.jpg',
                                style: AppStyles.h2,
                              ),
                            ),
                          ],
                        ),
                      ),
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
