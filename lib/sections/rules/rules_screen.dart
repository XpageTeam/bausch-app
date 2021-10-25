import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class RulesScreen extends StatefulWidget {
  final ScrollController controller;
  const RulesScreen({required this.controller, Key? key}) : super(key: key);

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final RulesCubit rulesCubit = RulesCubit();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.mystic,
          resizeToAvoidBottomInset: false,
          body: BlocBuilder<RulesCubit, RulesState>(
            bloc: rulesCubit,
            builder: (context, state) {
              if (state is RulesSuccess) {
                return SingleChildScrollView(
                  controller: widget.controller,
                  child: Html(
                    data: state.data,
                    shrinkWrap: true,
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator.adaptive());
            },
          ),
        ),
      ),
    );
  }
}
