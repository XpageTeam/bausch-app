// ignore_for_file: unused_import

import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/cubit/faq/faq_cubit.dart';
import 'package:bausch/sections/faq/question_screen.dart';
import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//* FAQ
//* topic

class TopicScreenArguments {
  final String title;
  final TopicModel topicModel;

  TopicScreenArguments({
    required this.title,
    required this.topicModel,
  });
}

class TopicScreen extends StatelessWidget implements TopicScreenArguments {
  final ScrollController controller;

  @override
  final String title;
  @override
  final TopicModel topicModel;

  const TopicScreen({
    required this.controller,
    required this.title,
    required this.topicModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        resizeToAvoidBottomInset: false,
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
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Keys.mainNav.currentState!.pop();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: StaticData.sidePadding,
                            left: StaticData.sidePadding,
                            top: 30,
                          ),
                          child: Text(
                            title,
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
                      text: topicModel.questions[index].title,
                      icon: Container(),
                      onPressed: () {
                        Keys.simpleBottomSheetNav.currentState!.pushNamed(
                          '/question',
                          arguments: QuestionScreenArguments(
                            question: topicModel.questions[index],
                            topic: topicModel,
                          ),
                        );
                      },
                    ),
                  ),
                  childCount: topicModel.questions.length,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              sliver: SupportSection(
                topic: topicModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
