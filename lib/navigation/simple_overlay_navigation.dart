import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/sections/faq/contact_support_screen.dart';
import 'package:bausch/sections/faq/topic_screen.dart';
import 'package:bausch/sections/faq/topics_screen.dart';
import 'package:bausch/sections/faq/question_screen.dart';
import 'package:bausch/sections/rules/cubit/rules_cubit.dart';
import 'package:bausch/sections/rules/rules_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';

//* Навигатор для bottomSheet'а без элементов каталога
class SimpleOverlayNavigation extends StatelessWidget {
  final ScrollController controller;
  final SimpleSheetModel sheetModel;

  const SimpleOverlayNavigation({
    required this.controller,
    required this.sheetModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: Keys.simpleBottomSheetNav,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case '/':
            if (sheetModel.type == SimpleSheetType.faq) {
              page = TopicsScreen(
                controller: controller,
              );
            } else if (sheetModel.type == SimpleSheetType.rules) {
              page = RulesScreen(
                controller: controller,
              );
            } else {
              page = Container();
            }
            break;

          case '/faq_topics':
            page = TopicsScreen(controller: controller);
            break;

          case '/faq_topic':
            page = TopicScreen(
              controller: controller,
              title: (settings.arguments as TopicScreenArguments).title,
              topicModel:
                  (settings.arguments as TopicScreenArguments).topicModel,
            );
            break;

          case '/rules':
            page = RulesScreen(
              controller: controller,
            );
            break;

          case '/question':
            page = QuestionScreen(
              controller: controller,
              question:
                  (settings.arguments as QuestionScreenArguments).question,
              answer: (settings.arguments as QuestionScreenArguments).answer,
            );
            break;

          case '/support':
            page = ContactSupportScreen(controller: controller);
            break;

          default:
            page = Container();
            break;
        }
        return PageRouteBuilder<dynamic>(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.easeInOutExpo);
            return SlideTransition(
              position: Tween(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: page,
            );
          },
        );
      },
    );
  }
}
