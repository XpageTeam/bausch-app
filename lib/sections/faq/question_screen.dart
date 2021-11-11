import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

//* FAQ
//* Answer
class QuestionScreenArguments {
  final QuestionModel question;
  final int topicId;

  QuestionScreenArguments({
    required this.question,
    required this.topicId,
  });
}

class QuestionScreen extends StatelessWidget
    implements QuestionScreenArguments {
  final ScrollController controller;

  @override
  final QuestionModel question;

  @override
  final int topicId;

  const QuestionScreen({
    required this.controller,
    required this.question,
    required this.topicId,
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
        body: CustomScrollView(
          controller: controller,
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 20,
                  ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.title,
                          style: AppStyles.h2,
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Html(
                          data: question.answer,
                          style: {
                            'body': Style(margin: EdgeInsets.zero),
                          },
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
              sliver: SupportSection(
                questionId: question.id,
                topicId: topicId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
