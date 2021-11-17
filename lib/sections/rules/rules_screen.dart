import 'package:bausch/sections/loader/widgets/animated_loader.dart';
import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/sections/rules/rules_listener.dart';
import 'package:bausch/sections/sheets/widgets/sliver_appbar.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class RulesScreen extends StatefulWidget {
  final ScrollController controller;
  final String data;

  const RulesScreen({required this.controller, required this.data, Key? key})
      : super(key: key);

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Scaffold(
            backgroundColor: AppTheme.mystic,
            //resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: StaticData.sidePadding,
              ),
              controller: widget.controller,
              child: Html(
                data: widget.data,
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
          ),
          // CustomSliverAppbar.toPop(
          //   icon: Container(),
          //   rightKey: Keys.mainNav,
          //   backgroundColor: Colors.white,
          // ),
          Padding(
            padding: const EdgeInsets.all(StaticData.sidePadding),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: IconButton(
                onPressed: () {
                  Keys.mainNav.currentState!.pop();
                },
                icon: const Icon(
                  Icons.close,
                  color: AppTheme.mineShaft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
