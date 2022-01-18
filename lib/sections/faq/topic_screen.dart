// ignore_for_file: unused_import

import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/cubit/faq/faq_cubit.dart';
import 'package:bausch/sections/faq/question_screen.dart';
import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
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
    return CustomSheetScaffold(
      controller: controller,
      appBar: const CustomSliverAppbar(
        padding: EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 26,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Частые вопросы',
                        style: AppStyles.h2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: StaticData.sidePadding,
                        left: StaticData.sidePadding,
                        top: 43,
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
                  style: AppStyles.h3,
                  text: topicModel.questions[index].title,
                  icon: Container(),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/question',
                      arguments: QuestionScreenArguments(
                        question: topicModel.questions[index],
                        topic: topicModel,
                        fields: topicModel.questions[index].fields,
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
    );
  }
}
