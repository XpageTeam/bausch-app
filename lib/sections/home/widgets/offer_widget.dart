import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.sulu, borderRadius: BorderRadius.circular(5)),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          IconButton(onPressed: () {}, icon: Icon(Icons.close)),
          Padding(
            padding: const EdgeInsets.only(
                top: 16,
                right: StaticData.sidePadding,
                left: StaticData.sidePadding,
                bottom: 30),
            child: Column(
              children: [
                Row(
                  children: const [
                    Flexible(
                      child: Text(
                        'Бесплатно подберем вам первые линзы в оптике',
                        style: AppStyles.h2,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    )
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    const Flexible(
                      child: Text(
                        'После подбора линз вы сможете получить в два раза больше баллов',
                        style: AppStyles.p1,
                      ),
                    ),
                    const SizedBox(
                      width: 45,
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Image.asset('assets/banner-icon.png'))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
