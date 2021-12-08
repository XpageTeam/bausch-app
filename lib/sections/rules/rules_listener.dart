import 'package:another_flushbar/flushbar.dart';
import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RulesListener extends StatelessWidget {
  final Widget child;
  const RulesListener({
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<RulesCubit, RulesState>(
      listener: (context, state) {
        if (state is RulesFailed) {
          Keys.mainNav.currentState!.pop();

          showDefaultNotification(title: state.title);
        }
      },
      child: child,
    );
  }
}
