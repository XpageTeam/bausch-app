import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';

class InfoSection extends StatelessWidget {
  final Widget view;
  const InfoSection({required this.view, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return view;
  }

  static InfoSection product() {
    return InfoSection(
      view: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 20,
            bottom: 40,
          ),
          child: Column(
            children: const [
              Text(
                'Однодневные контактные линзы из инновационного материала гипергель53, влагосодержание которого соответствует количеству воды в роговице глаза человека — 78%52.',
                style: AppStyles.p1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InfoSection webinar() {
    return InfoSection(
      view: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 20,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Программа вебинара, 60 минут:',
                style: AppStyles.h2,
              ),
              SizedBox(
                height: 22,
              ),
              TextWithPoint(
                text: 'Реальное влияние цифровых устройствна наши глаза',
                style: AppStyles.p1,
              ),
              SizedBox(
                height: 10,
              ),
              TextWithPoint(
                text:
                    'Компьютерный зрительный синдром: причины, симптомы и профилактика',
                style: AppStyles.p1,
              ),
              SizedBox(
                height: 10,
              ),
              TextWithPoint(
                text: 'Головные боли при работе с гаджетами',
                style: AppStyles.p1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InfoSection partners() {
    return InfoSection(
      view: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 20,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'More.TV - онлайн-платформа, предлагающая возможности стриминга эфирного вещания, а также просмотра самого востребованного российского и зарубежного контента как бесплатно по рекламной модели, так и с помощью платной подписки.',
                style: AppStyles.p1,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Как воспользоваться промокодом',
                style: AppStyles.h2,
              ),
              SizedBox(
                height: 22,
              ),
              TextWithPoint(
                text:
                    'После того, как вы выберите промокод, он будет храниться в личном кабинете. Ещё мы продублируем его вам на почту.',
                style: AppStyles.p1,
              ),
              SizedBox(
                height: 10,
              ),
              TextWithPoint(
                text:
                    'Активировать промокод вы сможете в любое время на сайте More.TV в разделе «Использовать ромокод»',
                style: AppStyles.p1,
              ),
              SizedBox(
                height: 10,
              ),
              TextWithPoint(
                text:
                    'Если вы используете мобильное приложение, войдите в профиль, используя те же данные пользователя.',
                style: AppStyles.p1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
