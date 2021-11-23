import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/sections/faq/topic_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

//* FAQ
//* topics
class TopicsScreen extends StatefulWidget {
  final ScrollController controller;
  final List<TopicModel> topics;
  const TopicsScreen({
    required this.controller,
    required this.topics,
    Key? key,
  }) : super(key: key);

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
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
          controller: widget.controller,
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
                      text: widget.topics[index].title,
                      icon: Container(),
                      onPressed: () {
                        Keys.simpleBottomSheetNav.currentState!.pushNamed(
                          '/faq_topic',
                          arguments: TopicScreenArguments(
                            title: widget.topics[index].title,
                            topicModel: widget.topics[index],
                          ),
                        );
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
        ),
      ),
    );
  }
}
