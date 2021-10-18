import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';

class LegalInfo extends StatelessWidget {
  const LegalInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Column(
        children: const [
          TextWithPoint(
            text:
                'Адрес доставки должен быть на территории Российской Федерации, за исключением Республики Крым (по правилам программы доставка в Крым и Севастополь не осуществляется).',
          ),
          SizedBox(
            height: 10,
          ),
          TextWithPoint(
            text:
                'Бесплатная упаковка будет направлена на указанный адрес не позднее 60 рабочих дней с момента заказа.',
          ),
          SizedBox(
            height: 10,
          ),
          TextWithPoint(
            text:
                'Организатор не несёт ответственность за невозможность доставки в связи с некорректным указанием адреса доставки и в случае невозможности связаться с получателем по указанному номеру телефона. Сроки доставки определяются организацией, осуществляющей доставку.',
          ),
          SizedBox(
            height: 10,
          ),
          TextWithPoint(
            text:
                'Внешний вид и комплектность подарочных изделий могут отличаться от изображений на сайте.',
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
