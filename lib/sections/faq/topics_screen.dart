import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/contact_support/contact_support_screen.dart';
import 'package:bausch/sections/faq/question_screen.dart';
import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/sections/faq/topic_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/sections/sheets/wm/bottom_sheet_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

//* FAQ
//* topics

class TopicsScreenArguments {
  final List<TopicModel> topics;

  TopicsScreenArguments({
    required this.topics,
  });
}

class TopicsScreen extends CoreMwwmWidget<BottomSheetWM>
    implements TopicsScreenArguments {
  final ScrollController controller;
  @override
  final List<TopicModel> topics;
  TopicsScreen({
    required this.controller,
    required this.topics,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (context) {
            return BottomSheetWM(
              color: Colors.white,
            );
          },
        );

  @override
  WidgetState<CoreMwwmWidget<BottomSheetWM>, BottomSheetWM>
      createWidgetState() => _TopicsScreenState();
}

class _TopicsScreenState extends WidgetState<TopicsScreen, BottomSheetWM> {
  Color iconColor = Colors.white;
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
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            icon: Container(height: 1),
            iconColor: color,
          );
        },
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
                        top: 42,
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
                  style: AppStyles.h3,
                  text: widget.topics[index].title,
                  icon: Container(),
                  onPressed: () {
                    if (widget.topics[index].questions != null &&
                        widget.topics[index].questions!.isNotEmpty) {
                      Navigator.of(context).pushNamed(
                        '/faq_topic',
                        arguments: TopicScreenArguments(
                          title: widget.topics[index].title,
                          topicModel: widget.topics[index],
                        ),
                      );
                    } else {
                      if (widget.topics[index].answer != null &&
                          widget.topics[index].answer!.isNotEmpty) {
                        Navigator.of(context).pushNamed(
                          '/question',
                          arguments: QuestionScreenArguments(
                            topic: widget.topics[index],
                          ),
                        );
                      } else {
                        Navigator.of(context).pushNamed(
                          '/support',
                          arguments: ContactSupportScreenArguments(
                            topic: widget.topics[index],
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
              childCount: widget.topics.length,
            ),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          sliver: SupportSection(),
        ),
      ],
    );
  }
}
