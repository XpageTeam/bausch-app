import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/sections/faq/cubit/faq/faq_cubit.dart';
import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextButtonsListener extends StatelessWidget {
  final Widget child;
  const TextButtonsListener({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FaqCubit, FaqState>(
          listener: (context, state) {
            if (state is FaqFailed) {
              if (Keys.mainNav.currentState!.canPop()) {
                Keys.mainNav.currentState!.pop();
              }

              showDefaultNotification(
                title: state.title,
                subtitle: state.subtitle,
              );
            }

            if (state is FaqLoading) {
              showLoader(context);
            }

            if (state is FaqSuccess) {
              if (Keys.mainNav.currentState!.canPop()) {
                Keys.mainNav.currentState!.pop();

                showSheet<List<TopicModel>>(
                  context,
                  SimpleSheetModel(
                    name: 'Частые вопросы',
                    type: 'faq',
                  ),
                  state.topics,
                );
              }
            }
          },
        ),
        BlocListener<RulesCubit, RulesState>(
          listener: (context, state) {
            if (state is RulesFailed) {
              if (Keys.mainNav.currentState!.canPop()) {
                Keys.mainNav.currentState!.pop();
              }

              showDefaultNotification(
                title: state.title,
                subtitle: state.subtitle,
              );
            }

            if (state is RulesLoading) {
              showLoader(context);
            }

            if (state is RulesSuccess) {
              if (Keys.mainNav.currentState!.canPop()) {
                Keys.mainNav.currentState!.pop();
                showSheet<String>(
                  context,
                  SimpleSheetModel(
                    name: 'Правила',
                    type: 'rules',
                  ),
                  state.data,
                );
              }
            }
          },
        ),
      ],
      child: child,
    );
  }
}
