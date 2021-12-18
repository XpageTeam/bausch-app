import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
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
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              controller: widget.controller,
              child: Html(
                data: 'state.data',
                style: {
                  'body': Style(
                    margin: EdgeInsets.zero,
                    color: AppTheme.mineShaft,
                  ),
                  'strong': Style(
                    fontSize: const FontSize(17),
                    fontWeight: FontWeight.w500,
                    height: 20 / 17,
                  ),
                  'h1': Style(
                    textAlign: TextAlign.center,
                    //alignment: Alignment.topCenter,
                    color: AppTheme.mineShaft,
                  ),
                },
                customRender: {
                  'table': (context, child) {
                    return SingleChildScrollView(
                      clipBehavior: Clip.none,
                      child: (context.tree as TableLayoutElement)
                          .toWidget(context),
                      scrollDirection: Axis.horizontal,
                    );
                  },
                },
              ),
            ),
            // CustomSliverAppbar.toPop(
            //   icon: Container(),
            // ),
          ],
        ),
      ),
    );
  }
}
