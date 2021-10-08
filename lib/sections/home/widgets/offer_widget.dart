import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.sulu,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 16,
              right: StaticData.sidePadding,
              left: StaticData.sidePadding,
              bottom: 30,
            ),
            child: Column(
              children: [
                Row(
                  children: const [
                    Flexible(
                      child: Text(
                        'Бесплатно подберем вам первые линзы в оптике',
                        style: AppStyles.h1,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                    ),
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
                    InkWell(
                      onTap: () {},
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/banner-icon.png',
                            height: 60,
                          ),
                          const Positioned(
                            child: Icon(Icons.arrow_forward_sharp),
                            right: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.close),
          splashRadius: 5,
        ),
      ],
    );
  }
}
