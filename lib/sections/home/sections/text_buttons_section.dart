import 'package:bausch/sections/faq/cubit/faq/faq_cubit.dart';
import 'package:bausch/sections/home/widgets/listeners/text_buttons_listener.dart';
import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/buttons/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

class TextButtonsSection extends StatefulWidget {
  const TextButtonsSection({Key? key}) : super(key: key);

  @override
  State<TextButtonsSection> createState() => _TextButtonsSectionState();
}

class _TextButtonsSectionState extends State<TextButtonsSection> {
  final FaqCubit faqCubit = FaqCubit();
  final RulesCubit rulesCubit = RulesCubit();

  @override
  void dispose() {
    super.dispose();
    faqCubit.close();
    rulesCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => faqCubit),
        BlocProvider(create: (context) => rulesCubit),
      ],
      child: TextButtonsListener(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomTextButton(
              title: 'Правила программы',
              onPressed: () {
                rulesCubit.loadData(RulesOrLinks.rules);
              },
            ),
            // CustomTextButton(
            //   title: 'Частые вопросы',
            //   onPressed: faqCubit.loadData,
            // ),
            CustomTextButton(
              title: 'Библиотека ссылок',
              onPressed: () {
                rulesCubit.loadData(RulesOrLinks.links);
              },
            ),
            CustomTextButton(
              title: 'Обработка персональных\nданных',
              onPressed: () async {
                // openSimpleWebView(
                //   context,
                //   url: StaticData.privacyPolicyLink,
                // );
                if (await canLaunchUrlString(StaticData.privacyPolicyLink)) {
                  await launchUrlString(
                    StaticData.privacyPolicyLink,
                    // TODO(info): везде pdf открывать так
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
