import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/sections/faq/topic_screen.dart';
import 'package:bausch/sections/sheets/widgets/custom_sheet_scaffold.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';

//* FAQ
//* topics

class TopicsScreenArguments {
  final List<TopicModel> topics;

  TopicsScreenArguments({
    required this.topics,
  });
}

class TopicsScreen extends StatefulWidget implements TopicsScreenArguments {
  final ScrollController controller;
  @override
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
    return CustomSheetScaffold(
      controller: widget.controller,
      appBar: CustomSliverAppbar(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        icon: Container(height: 1),
        //iconColor: AppTheme.mystic,
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
                    Navigator.of(context).pushNamed(
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
    );
  }
}
