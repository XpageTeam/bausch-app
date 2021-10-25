import 'package:bausch/sections/faq/cubit/faq_cubit.dart';
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
//* topics / topic
class FaqScreen extends StatefulWidget {
  final ScrollController controller;
  const FaqScreen({required this.controller, Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final FaqCubit faqCubit = FaqCubit();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FaqCubit, FaqState>(
      bloc: faqCubit,
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
                                  .pushNamed('/question');
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
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
        );
      },
    );
  }
}
