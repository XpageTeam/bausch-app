import 'package:bausch/sections/order_registration/widgets/marked_text_row.dart';
import 'package:flutter/material.dart';

class DeliveryInfoWidget extends StatelessWidget {
  const DeliveryInfoWidget({Key? key}) : super(key: key);
  static final deliveryInfoStrings = [
    'Адрес доставки должен быть на территории Российской Федерации, за исключением Республики Крым (по правилам программы доставка в Крым и Севастополь не осуществляется).',
    'Бесплатная упаковка будет направлена на указанный адрес не позднее 60 рабочих дней с момента заказа.',
    'Организатор не несёт ответственность за невозможность доставки в связи с некорректным указанием адреса доставки и в случае невозможности связаться с получателем по указанному номеру телефона. Сроки доставки определяются организацией, осуществляющей доставку.',
    'Внешний вид и комплектность подарочных изделий могут отличаться от изображений на сайте.',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: deliveryInfoStrings.fold<List<Widget>>(
        [],
        (aggregatedList, item) {
          aggregatedList.add(
            MarkedTextRow(text: item),
          );
          if (item != deliveryInfoStrings.last) {
            aggregatedList.add(
              const SizedBox(height: 10),
            );
          }

          return aggregatedList;
        },
      ).toList(),
    );
  }
}
