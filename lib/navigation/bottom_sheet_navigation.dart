// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/help/utils.dart';
import 'package:bausch/main.dart';
import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/consultattion_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/models/offer/offer.dart';
import 'package:bausch/models/orders_data/partner_order_response.dart';
import 'package:bausch/models/sheets/base_catalog_sheet_model.dart';
import 'package:bausch/sections/faq/attach_files_screen.dart';
import 'package:bausch/sections/faq/contact_support/contact_support_screen.dart';
import 'package:bausch/sections/faq/question_screen.dart';
import 'package:bausch/sections/faq/topic_screen.dart';
import 'package:bausch/sections/faq/topics_screen.dart';
import 'package:bausch/sections/my_lenses/my_lenses_wm.dart';
import 'package:bausch/sections/rules/rules_screen.dart';
import 'package:bausch/sections/sheets/screens/add_points/add_points_details.dart';
import 'package:bausch/sections/sheets/screens/add_points/add_points_screen.dart';
import 'package:bausch/sections/sheets/screens/add_points/final_add_points.dart';
import 'package:bausch/sections/sheets/screens/add_points/quiz/quiz_screen.dart';
import 'package:bausch/sections/sheets/screens/consultation/consultation_screen.dart';
import 'package:bausch/sections/sheets/screens/consultation/consultation_verification.dart';
import 'package:bausch/sections/sheets/screens/consultation/final_consultation.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_optics_verification.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/final_discount_optics.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:bausch/sections/sheets/screens/html/html_screen.dart';
import 'package:bausch/sections/sheets/screens/partners/final_partners.dart';
import 'package:bausch/sections/sheets/screens/partners/partners_screen.dart';
import 'package:bausch/sections/sheets/screens/partners/partners_verification.dart';
import 'package:bausch/sections/sheets/screens/program/final_program_screen.dart';
import 'package:bausch/sections/sheets/screens/program/program_screen.dart';
import 'package:bausch/sections/sheets/screens/program/widget_model/program_screen_wm.dart';
import 'package:bausch/sections/sheets/screens/webinars/all_webinars_screen.dart';
import 'package:bausch/sections/sheets/screens/webinars/final_webinar.dart';
import 'package:bausch/sections/sheets/screens/webinars/webinar_screen.dart';
import 'package:bausch/sections/sheets/screens/webinars/webinar_verification.dart';
import 'package:bausch/sections/sheets/screens/webinars/widget_models/webinar_verification_wm.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomSheetNavigation<T> extends StatelessWidget {
  final ScrollController controller;
  final BaseCatalogSheetModel sheetModel;
  final T? args;

  // Этот параметр нужен для того, чтоб
  // из секции "вам может быть интересно" можно было перейти
  // сразу в товар
  String? initialRoute;
  MyLensesWM? myLensesWM;
  BottomSheetNavigation({
    required this.controller,
    required this.sheetModel,
    this.args,
    this.initialRoute,
    this.myLensesWM,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Utils.unfocus(context);
      },
      child: Navigator(
        key: Keys.bottomNav,
        requestFocus: false,
        initialRoute: '/',
        onPopPage: (route, dynamic settings) {
          Utils.unfocus(context);
          return true;
        },
        onGenerateRoute: (settings) {
          Widget page;

          Utils.unfocus(context);

          final arguments = initialRoute != null
              ? args ?? settings.arguments
              : settings.arguments;

          switch (initialRoute ?? settings.name) {
            case '/':
              if (sheetModel.type == 'online_consultation') {
                page = ConsultationScreen(
                  controller: controller,
                  model: (args as List<CatalogItemModel>).first
                      as ConsultationItemModel,
                );
              } else if (sheetModel.type == 'program') {
                page = ProgramScreen(
                  controller: controller,
                );
              } else if (sheetModel.type == 'add_points') {
                page = AddPointsScreen(
                  controller: controller,
                  myLensesWM: myLensesWM,
                );
              } else if (sheetModel.type == 'faq') {
                page = TopicsScreen(
                  controller: controller,
                  topics: args as List<TopicModel>,
                );
              } else if (sheetModel.type == 'rules') {
                page = RulesScreen(
                  controller: controller,
                  data: args as String,
                );
              } else if (sheetModel.type == 'support') {
                final supportArgs = args as ContactSupportScreenArguments;

                page = ContactSupportScreen(
                  controller: controller,
                  question: supportArgs.question,
                  topic: supportArgs.topic,
                );
              } else {
                page = SheetScreen(
                  sheetModel: sheetModel,
                  controller: controller,
                  items: args as List<CatalogItemModel>,
                  //path: path(sheetModel.type),
                );
              }

              break;

            // case '/free_product':
            //   arguments as ItemSheetScreenArguments;

            //   AppsflyerSingleton.sdk.logEvent('freePack', <String, dynamic>{
            //     'id': arguments.model.id,
            //     'title': arguments.model.name,
            //   });

            //   page = FreePackagingScreen(
            //     controller: controller,
            //     model: arguments.model,
            //   );
            //   break;

            case '/add_points':
              page = AddPointsScreen(
                controller: controller,
                myLensesWM: myLensesWM,
              );
              break;

            case '/offline':
              page = DiscountOpticsScreen(
                controller: controller,
                model: (arguments as ItemSheetScreenArguments).model
                    as PromoItemModel,
                section: arguments.section,
                discount: sheetModel.discount,
              );
              break;

            case '/onlineShop':
              arguments as ItemSheetScreenArguments;

              AppsflyerSingleton.sdk
                  .logEvent('discountOpticsShow', <String, dynamic>{
                'id': arguments.model.id,
                'title': arguments.model.name,
              });
              page = DiscountOpticsScreen(
                controller: controller,
                model: arguments.model as PromoItemModel,
                section: arguments.section,
                discount: sheetModel.discount,
              );
              break;

            case '/promo_code_immediately':
              // AppsflyerSingleton.sdk.logEvent('discountOpticsShow', null);
              page = PartnersScreen(
                controller: controller,
                model: (arguments as ItemSheetScreenArguments).model
                    as PartnersItemModel,
              );
              break;

            case '/promo_code_video':
              page = WebinarScreen(
                controller: controller,
                model: (arguments as ItemSheetScreenArguments).model
                    as WebinarItemModel,
              );

              break;

            case '/verification_discount_optics':
              page = DiscountOpticsVerification(
                controller: controller,
                model: (settings.arguments as DiscountOpticsArguments).model
                    as PromoItemModel,
                section:
                    (settings.arguments as DiscountOpticsArguments).section,
                discountOptic: (settings.arguments as DiscountOpticsArguments)
                    .discountOptic,
                discountCount: sheetModel.discount,
              );
              break;

            case '/verification_webinar':
              page = WebinarVerification(
                controller: controller,
                model: (settings.arguments as ItemSheetScreenArguments).model
                    as WebinarItemModel,
              );
              break;

            case '/verification_partners':
              page = PartnersVerification(
                controller: controller,
                model: (settings.arguments as ItemSheetScreenArguments).model
                    as PartnersItemModel,
              );
              break;

            case '/final_webinar':
              page = FinalWebinar(
                controller: controller,
                model: (settings.arguments as FinalWebinarArguments).model,
                videoIds:
                    (settings.arguments as FinalWebinarArguments).videoIds,
              );
              break;

            case '/all_webinars':
              page = AllWebinarsScreen(
                controller: controller,
                arguments: arguments as ItemSheetScreenArguments,
              );
              break;

            case '/final_partners':
              final arguments = settings.arguments as ItemSheetScreenArguments;

              page = FinalPartners(
                controller: controller,
                model: arguments.model as PartnersItemModel,
                orderData: arguments.orderData as PartnerOrderResponse,
              );
              break;

            case '/final_discount_optics':
              page = FinalDiscountOptics(
                controller: controller,
                model: (settings.arguments as DiscountOpticsArguments).model
                    as PromoItemModel,
                section:
                    (settings.arguments as DiscountOpticsArguments).section,
                discountOptic: (settings.arguments as DiscountOpticsArguments)
                    .discountOptic,
                orderData: (settings.arguments as DiscountOpticsArguments)
                    .orderDataResponse,
              );
              break;

            case '/online_consultation':
              AppsflyerSingleton.sdk.logEvent('onlineConsultationShow', null);

              page = ConsultationScreen(
                controller: controller,
                model:
                    (settings.arguments as ConsultationScreenArguments).model,
              );
              break;

            case '/program':
              page = ProgramScreen(controller: controller);
              break;

            case '/final_program':
              final arguments = settings.arguments as Map<String, dynamic>;
              page = FinalProgramScreen(
                controller: controller,
                optic: arguments['optic'] as Optic,
                response: arguments['response'] as ProgramSaverResponse,
              );
              break;

            case '/addpoints_details':
              page = AddPointsDetails(
                model: (settings.arguments as AddPointsDetailsArguments).model,
                controller: controller,
              );
              break;

            case '/addpoints_quiz':
              page = QuizScreen(
                controller: controller,
                model: (settings.arguments as QuizScreenArguments).model,
              );
              break;

            case '/final_addpoints':
              page = FinalAddPointsScreen(
                controller: controller,
                points: (settings.arguments as FinalAddPointsArguments).points,
                message:
                    (settings.arguments as FinalAddPointsArguments).message,
                productBausch: (settings.arguments as FinalAddPointsArguments)
                    .productBausch,
                myLensesWM:
                    (settings.arguments as FinalAddPointsArguments).myLensesWM,
              );
              break;

            case '/verification_consultation':
              page = ConsultationVerification(
                controller: controller,
                model: (settings.arguments as ItemSheetScreenArguments).model
                    as ConsultationItemModel,
              );
              break;

            case '/final_consultation':
              page = FinalConsultation(
                controller: controller,
                model: (settings.arguments as ItemSheetScreenArguments).model
                    as ConsultationItemModel,
                orderData:
                    (settings.arguments as ItemSheetScreenArguments).orderData!,
              );
              break;

            case '/faq_topics':
              page = TopicsScreen(
                controller: controller,
                topics: (settings.arguments as TopicsScreenArguments).topics,
              );
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
                data: args as String,
              );
              break;

            case '/question':
              page = QuestionScreen(
                controller: controller,
                question:
                    (settings.arguments as QuestionScreenArguments).question,
                topic: (settings.arguments as QuestionScreenArguments).topic,
              );
              break;

            case '/support':
              final args = settings.arguments as ContactSupportScreenArguments;

              debugPrint(
                'topic1: ${args.topic}, question1: ${args.question}',
              );
              page = ContactSupportScreen(
                controller: controller,
                question: args.question,
                topic: args.topic,
              );
              break;

            case '/add_files':
              page = AttachFilesScreen(
                formScreenWM: (settings.arguments as AttachFilesScreenArguments)
                    .formScreenWM,
                fieldModel: (settings.arguments as AttachFilesScreenArguments)
                    .fieldModel,
              );
              break;

            case '/content':
              page = HtmlScreen(
                controller: controller,
                offer: arguments as Offer,
              );
              break;

            default:
              page = Container();
          }

          initialRoute = null;

          return PageRouteBuilder<void>(
            pageBuilder: (_, __, ___) => page,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
          // if (Platform.isIOS) {
          //   return CupertinoPageRoute<void>(builder: (context) {
          //     return page;
          //   });
          // } else {
          //   return MaterialPageRoute<void>(builder: (context) {
          //     return page;
          //   });
          // }
        },
      ),
    );
  }
}
