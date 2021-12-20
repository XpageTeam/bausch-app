import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

//* FAQ
//* Answer
class QuestionScreenArguments {
  final QuestionModel question;
  final TopicModel topic;

  QuestionScreenArguments({
    required this.question,
    required this.topic,
  });
}

class QuestionScreen extends StatelessWidget
    implements QuestionScreenArguments {
  final ScrollController controller;

  @override
  final QuestionModel question;

  @override
  final TopicModel topic;

  const QuestionScreen({
    required this.controller,
    required this.question,
    required this.topic,
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
              const SizedBox(
                height: 26,
              ),
              Center(
                child: Text(
                  'Частые вопросы',
                  style: AppStyles.h2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 12,
                  left: 12,
                  top: 43,
                  bottom: 92,
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
                      style: htmlStyles,
                      customRender: htmlCustomRender,
                      onLinkTap: (url, context, attributes, element) async {
                        if (url != null) {
                          if (await canLaunch(url)) {
                            try {
                              await launch(url);

                              return;
                              // ignore: avoid_catches_without_on_clauses
                            } catch (e) {
                              debugPrint('url: $url - не может быть открыт');
                            }
                          }
                        }

                        debugPrint('url: $url - не может быть открыт');
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
            question: question,
            topic: topic,
          ),
        ),
      ],
    );
  }
}
