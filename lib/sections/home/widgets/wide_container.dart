import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class WideContainer extends StatelessWidget {
  final List<String>? children;
  final String? img;
  final String? title;
  final String? subtitle;
  const WideContainer({
    this.img,
    this.children,
    this.title,
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title ?? 'Скидка в оптике',
              style: AppStyles.h2Bold,
            ),
            Row(
              children: [
                Flexible(
                  child: Text(
                    subtitle ??
                        'Скидка на выбранный товар будет дейстовать в любой из оптик сети',
                    style: AppStyles.p1,
                  ),
                ),
                Image.asset(
                  img ?? 'assets/discount-in-optics.png',
                  height: 40,
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            if (children != null)
              Center(
                child: SizedBox(
                  height: 32,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return Image.asset(
                        children![i],
                        width: 100,
                      );
                    },
                    separatorBuilder: (context, i) {
                      return const VerticalDivider();
                    },
                    itemCount: children!.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
