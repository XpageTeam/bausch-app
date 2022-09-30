import 'dart:async';

import 'package:bausch/main.dart';
import 'package:bausch/models/add_points/add_points_model.dart';
import 'package:bausch/models/add_points/quiz/quiz_model.dart';
import 'package:bausch/sections/sheets/screens/add_points/add_points_details.dart';
import 'package:bausch/sections/sheets/screens/add_points/quiz/quiz_screen.dart';
import 'package:bausch/sections/sheets/screens/add_points/widget_models/add_points_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/button_with_points_content.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

//* Элемент, после нажатия на который, происходит переход на страницу добавления баллов
class AddItem extends StatelessWidget {
  final AddPointsModel model;

  final AddPointsWM wm;

  const AddItem({
    required this.model,
    required this.wm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        unawaited(AppsflyerSingleton.sdk.logEvent('pointsAction', <String, dynamic>{
          'id': model.id,
          'title': model.previewModel.title,
        }));

        if (model.type == 'quiz') {
          await Navigator.of(context).pushNamed(
            '/addpoints_quiz',
            arguments: QuizScreenArguments(
              model: model as QuizModel,
            ),
          );

          unawaited(wm.loadInfoAction());
        } else if (model.type == 'double_points') {
          debugPrint('double points');
        } else if (model.type == 'birthday') {
          await Keys.mainContentNav.currentState!.pushNamed(
            '/profile_settings',
          );

          unawaited(wm.loadInfoAction());
        } else {
          await Navigator.of(context).pushNamed(
            '/addpoints_details',
            arguments: AddPointsDetailsArguments(
              model: model,
            ),
          );

          unawaited(wm.loadInfoAction());
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: StaticData.sidePadding,
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.previewModel.title,
                        style: AppStyles.h2,
                        // maxLines: 3,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        model.previewModel.description,
                        style: AppStyles.p1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                ButtonContent(price: '+${model.reward}'),
              ],
            ),
            if (model.type == 'birthday')
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 12,
                ),
                child: TextButton(
                  onPressed: () async {
                    await Keys.mainContentNav.currentState!.pushNamed(
                      '/profile_settings',
                    );

                    unawaited(FirebaseAnalytics.instance
                        .logEvent(name: 'birthdate_filling'));

                    unawaited(wm.loadInfoAction());
                    // Keys.mainContentNav.currentState!.pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.mystic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: StaticData.sidePadding,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 26, bottom: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Заполнить профиль',
                              style: AppStyles.h2,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 18,
                        color: AppTheme.mineShaft,
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
