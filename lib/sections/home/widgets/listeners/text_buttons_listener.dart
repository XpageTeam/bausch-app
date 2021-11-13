import 'package:another_flushbar/flushbar.dart';
import 'package:bausch/models/sheets/folder/simple_sheet_model.dart';
import 'package:bausch/sections/faq/cubit/faq/faq_cubit.dart';
import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
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
              Keys.mainNav.currentState!.pop();

              showFlushbar(state.title);
            }

            if (state is FaqLoading) {
              showLoader(context);
            }

            if (state is FaqSuccess) {
              Keys.mainNav.currentState!.pop();

              showSimpleSheet(
                context,
                SimpleSheetModel(
                  title: 'Частые вопросы',
                  type: SimpleSheetType.faq,
                ),
                state.topics,
              );
            }
          },
        ),
        BlocListener<RulesCubit, RulesState>(
          listener: (context, state) {
            if (state is RulesFailed) {
              Keys.mainNav.currentState!.pop();

              showFlushbar(state.title);
            }

            if (state is RulesLoading) {
              showLoader(context);
            }

            if (state is RulesSuccess) {
              Keys.mainNav.currentState!.pop();

              showSimpleSheet(
                context,
                SimpleSheetModel(
                  title: 'Rules',
                  type: SimpleSheetType.rules,
                ),
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
