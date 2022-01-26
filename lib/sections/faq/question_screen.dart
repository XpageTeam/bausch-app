import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/wm/question_screen_wm.dart';
import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/html_styles.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:surf_mwwm/surf_mwwm.dart';
import 'package:url_launcher/url_launcher.dart';

//* FAQ
//* Answer
class QuestionScreenArguments {
  final QuestionModel? question;
  final TopicModel topic;

  QuestionScreenArguments({
    required this.topic,
    this.question,
  });
}

class QuestionScreen extends CoreMwwmWidget<QuestionScreenWM>
    implements QuestionScreenArguments {
  final ScrollController controller;

  @override
  final QuestionModel? question;

  @override
  final TopicModel topic;

  QuestionScreen({
    required this.controller,
    required this.topic,
    this.question,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) {
            return QuestionScreenWM();
          },
        );

  @override
  WidgetState<CoreMwwmWidget<QuestionScreenWM>, QuestionScreenWM>
      createWidgetState() => _QuestionScreenState();
}

class _QuestionScreenState
    extends WidgetState<QuestionScreen, QuestionScreenWM> {
  @override
  Widget build(BuildContext context) {
    return CustomSheetScaffold(
      controller: widget.controller,
      onScrolled: (offset) {
        if (offset > 60) {
          wm.colorState.accept(AppTheme.turquoiseBlue);
        } else {
          wm.colorState.accept(Colors.white);
        }
      },
      appBar: StreamedStateBuilder<Color>(
        streamedState: wm.colorState,
        builder: (_, color) {
          return CustomSliverAppbar(
            iconColor: color,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          );
        },
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
                      widget.question?.title ?? widget.topic.title,
                      style: AppStyles.h2,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Html(
                      data: (widget.question?.answer ?? widget.topic.answer) ??
                          '',
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
            question: widget.question,
            topic: widget.topic,
          ),
        ),
      ],
    );
  }
}
