import 'package:bausch/sections/faq/cubit/faq_cubit.dart';
import 'package:bausch/sections/faq/faq_listener.dart';
import 'package:bausch/sections/faq/support_section.dart';
import 'package:bausch/sections/faq/topic_screen.dart';
import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/buttons/white_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//* FAQ
//* topics
class TopicsScreen extends StatefulWidget {
  final ScrollController controller;
  const TopicsScreen({required this.controller, Key? key}) : super(key: key);

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final FaqCubit faqCubit = FaqCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: faqCubit,
      child: FaqListener(
        child: BlocBuilder<FaqCubit, FaqState>(
          builder: (context, state) {
            if (state is FaqSuccess) {
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
                                  const Padding(
                                    padding: EdgeInsets.only(
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
                                text: state.topics[index].title,
                                icon: Container(),
                                onPressed: () {
                                  Keys.simpleBottomSheetNav.currentState!
                                      .pushNamed(
                                    '/faq_topic',
                                    arguments: TopicScreenArguments(
                                      title: state.topics[index].title,
                                      topicModel: state.topics[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                            childCount: state.topics.length,
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
            return const ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              child: Scaffold(
                body: Center(
                  child: AnimatedLoader(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
