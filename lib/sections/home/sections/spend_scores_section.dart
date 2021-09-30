import 'package:bausch/sections/home/small_container.dart';
import 'package:bausch/sections/home/wide_container.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class SpendScores extends StatelessWidget {
  const SpendScores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Потратить баллы',
          style: AppStyles.h2,
        ),
        const SizedBox(
          height: 20,
        ),
        const WideContainer(
          children: [
            'assets/logos/logo1.png',
            'assets/logos/logo2.png',
            'assets/logos/logo3.png',
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: const [
            SmallContainer(
              title: 'Предложения от партнеров',
              number: '2',
              img: 'assets/offers-from-partners.png',
            ),
            SizedBox(
              width: 4,
            ),
            SmallContainer(
              title: 'Бесплатная упаковка',
              number: '2',
              img: 'assets/free-packaging.png',
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: const [
            SmallContainer(
              title: 'Скидка в интернет-магазине',
              number: '2',
              img: 'assets/discount-in-online-store.png',
            ),
            SizedBox(
              width: 4,
            ),
            SmallContainer(
              title: 'Записи вебинаров',
              number: '2',
              img: 'assets/webinar-recordings.png',
            ),
          ],
        ),
        const SizedBox(
          height: 4,
        ),
        WideContainer(
          title: 'Онлайн-консультация',
          subtitle: 'Любые вопросы офтальмологу из клиники Медси',
          img: 'assets/online-consultations.png',
        ),
      ],
    );
  }
}
