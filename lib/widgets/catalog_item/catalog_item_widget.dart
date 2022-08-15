// ignore_for_file: avoid-returning-widgets

import 'package:bausch/models/catalog_item/catalog_item_model.dart';
import 'package:bausch/models/catalog_item/partners_item_model.dart';
import 'package:bausch/models/catalog_item/product_item_model.dart';
import 'package:bausch/models/catalog_item/promo_item_model.dart';
import 'package:bausch/models/catalog_item/webinar_item_model.dart';
import 'package:bausch/models/faq/question_model.dart';
import 'package:bausch/models/faq/topic_model.dart';
import 'package:bausch/models/sheets/simple_sheet_model.dart';
import 'package:bausch/packages/bottom_sheet/bottom_sheet.dart';
import 'package:bausch/sections/faq/contact_support/contact_support_screen.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/discount_type.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/final_discount_optics.dart';
import 'package:bausch/sections/sheets/sheet_methods.dart';
import 'package:bausch/sections/sheets/sheet_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/123/default_notification.dart';
import 'package:bausch/widgets/point_widget.dart';
import 'package:bausch/widgets/webinar_popup/webinar_popup.dart';
//import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CatalogItemWidget extends StatelessWidget {
  final CatalogItemModel model;
  final String? orderTitle;
  final String? address;
  final String? deliveryInfo;

  const CatalogItemWidget({
    required this.model,
    this.orderTitle,
    this.address,
    this.deliveryInfo,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO(pavlov): еще должен выезжать поп ап, в нем добавить на что скидка распространяется и когда закончится
    debugPrint(model.picture);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          StaticData.sidePadding,
          20,
          StaticData.sidePadding,
          (model is ProductItemModel) ? 20 : 12,
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //* Название заказа
                      if (orderTitle != null)
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 2),
                            child: Text(
                              orderTitle!,
                              style: AppStyles.p1Grey,
                            ),
                          ),
                        ),

                      //* Название товара
                      Flexible(
                        child: Text(
                          model.name,
                          style: AppStyles.h2Bold,
                        ),
                      ),

                        // TODO(pavlov): сюда добавить название скидочного товара

                      //* Цена и виджет баллов
                      if (model.price > 0)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  model.priceToString,
                                  style: AppStyles.h2Bold,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const PointWidget(textStyle: AppStyles.h2),
                            ],
                          ),
                        ),

                        // TODO(pavlov): сюда добавить дату окончания промокода

                      //* Адрес
                      if (model is ProductItemModel && address != null)
                        Flexible(
                          child: Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              'Адрес: $address',
                              style: AppStyles.p1Grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                //* Изображение товара
                Container(
                  width: 100,
                  // constraints: const BoxConstraints(
                  //   minHeight: 100,
                  // ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: model.picture != null
                      ? !model.picture!.contains('http')
                          ? ExtendedImage.asset(
                              img(model)!, //! model.img
                              scale: 3,
                            )
                          : ExtendedImage.network(
                              model.picture!,
                              scale: 3,
                              printError: false,
                              loadStateChanged: loadStateChangedFunction,
                            )
                      : null,
                ),
              ],
            ),

            //* Информация о доставке
            if ((model is ProductItemModel) && deliveryInfo != null)
              Container(
                margin: const EdgeInsets.only(top: 26),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: Image.asset(
                        'assets/substract.png',
                        height: 15,
                      ),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: '$deliveryInfo. ',
                          style: AppStyles.p1,
                          children: [
                            if (deliveryInfo!
                                    .toLowerCase()
                                    .contains('доставлен') ||
                                deliveryInfo!
                                    .toLowerCase()
                                    .contains('выполнен'))
                              TextSpan(
                                style: AppStyles.p1Grey,
                                children: [
                                  const TextSpan(
                                    text: 'Eсли нет, пишите ',
                                  ),
                                  TextSpan(
                                    text: 'сюда',
                                    style: AppStyles.p1Grey.copyWith(
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // unawaited(showSheet<List<TopicModel>>(
                                        //   context,
                                        //   SimpleSheetModel(
                                        //     name: 'Частые вопросы',
                                        //     type: 'faq',
                                        //   ),
                                        //   [],
                                        // ));

                                        // await Future<void>.delayed(const Duration(seconds: 1));

                                        // await Keys.bottomNav.currentState!
                                        //     .pushNamedAndRemoveUntil(
                                        //   '/support',
                                        //   (route) => false,
                                        //   arguments:
                                        //       ContactSupportScreenArguments(
                                        //     question: QuestionModel(
                                        //       id: 179,
                                        //       title: '',
                                        //     ),
                                        //     topic: TopicModel(
                                        //       id: 24,
                                        //       title: '',
                                        //       questions: [],
                                        //     ),
                                        //   ),
                                        // );

                                        showSheet<
                                            ContactSupportScreenArguments>(
                                          context,
                                          SimpleSheetModel(
                                            name: 'Обратиться в поддержку',
                                            type: 'support',
                                          ),
                                          ContactSupportScreenArguments(
                                            question: QuestionModel(
                                              id: 179,
                                              title:
                                                  'Заказ: я не получил(а) бесплатные линзы (прошло более 60 дней)',
                                            ),
                                            topic: TopicModel(
                                              id: 22,
                                              title: 'Программа Лояльности',
                                              questions: [],
                                            ),
                                            orderID: model.id,
                                          ),
                                        );

                                        // Navigator.of(context).pushNamed(
                                        //   '/support',
                                        //   arguments:
                                        //       ContactSupportScreenArguments(
                                        //     question: QuestionModel(
                                        //       id: 179,
                                        //       title: '',
                                        //     ),
                                        //     topic: TopicModel(
                                        //       id: 24,
                                        //       title: '',
                                        //       questions: [],
                                        //     ),
                                        //   ),
                                        // );
                                      },
                                  ),
                                  const TextSpan(
                                    text: ', разберемся',
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (model is! ProductItemModel)
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: GreyButton(
                  text: txt(model),
                  icon: icon(model),
                  onPressed: () {
                    callback(
                      model,
                      allWebinarsOpen: () =>
                          showSheet<ItemSheetScreenArguments>(
                        context,
                        SimpleSheetModel(
                          name: 'Title',
                          type: 'promo_code_video',
                        ),
                        ItemSheetScreenArguments(model: model),
                        '/all_webinars',
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  //* Вывод нужной картинки в зависимости от типа элемента
  String? img(CatalogItemModel model) {
    if (model is WebinarItemModel) {
      return 'assets/webinar-recordings.png';
    } else if (model is ProductItemModel) {
      return model.picture;
    } else if (model is PartnersItemModel) {
      return 'assets/offers-from-partners.png';
    } else {
      return 'assets/discount-in-optics.png';
    }
  }
}

//* Вывод нужной надписи в зависимости от типа элемента
String txt(CatalogItemModel model) {
  if (model is WebinarItemModel) {
    return 'Перейти к просмотру';
  } else if (model is PartnersItemModel) {
    return model.poolPromoCode ?? '';
  } else {
    return (model as PromoItemModel).code;
  }
}

Widget icon(CatalogItemModel model) {
  if (model is WebinarItemModel) {
    return Container();
  } else if (model is PartnersItemModel) {
    return Image.asset(
      'assets/copy.png',
      height: 16,
    );
  } else {
    return Image.asset(
      'assets/icons/preview.png',
      height: 16,
    );
  }
}

void callback(CatalogItemModel model, {VoidCallback? allWebinarsOpen}) {
  if (model is WebinarItemModel) {
    if (model.videoIds.length > 1) {
      allWebinarsOpen?.call();
    } else {
      showDialog<void>(
        context: Keys.mainNav.currentContext!,
        builder: (context) => WebinarPopup(
          videoId: model.videoIds.first,
        ),
      );
    }
  } else if (model is PartnersItemModel) {
    Clipboard.setData(ClipboardData(text: model.poolPromoCode));
    showDefaultNotification(
      title: 'Скопировано!',
      success: true,
    );
  } else {
    showFlexibleBottomSheet<void>(
      context: Keys.mainNav.currentContext!,
      minHeight: 0,
      initHeight: 0.9,
      maxHeight: 0.95,
      anchors: [0, 0.6, 0.95],
      builder: (context, controller, d) {
        return FinalDiscountOptics(
          discountType: DiscountType.offline,
          controller: ScrollController(),
          model: model as PromoItemModel,
          buttonText: 'Готово',
        );
      },
    );
  }
}

class GreyButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback? onPressed;
  const GreyButton({
    required this.text,
    required this.icon,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.mystic,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppStyles.h2,
            ),
            const SizedBox(
              width: 10,
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
