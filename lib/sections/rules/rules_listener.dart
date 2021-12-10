import 'package:another_flushbar/flushbar.dart';
import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
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

          //TODO(Nikita): поменять на готовую функцию
          Flushbar<void>(
            messageText: Text(
              state.title,
              textAlign: TextAlign.center,
              style: AppStyles.p1White,
            ),
            duration: const Duration(
              seconds: 3,
            ),
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5),
            ),
          ).show(Keys.mainNav.currentContext!);
        }
      },
      child: child,
    );
  }
}
