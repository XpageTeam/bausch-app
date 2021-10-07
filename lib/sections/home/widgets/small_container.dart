import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';

class SmallContainer extends StatelessWidget {
  final String title;
  final String number;
  final String img;
  const SmallContainer(
      {required this.title, required this.number, required this.img, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2,
      height:
          MediaQuery.of(context).size.width / 2 - StaticData.sidePadding - 2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 14,
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AutoSizeText(
              title,
              style: AppStyles.h1,
              maxLines: 2,
              overflow: TextOverflow.visible,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  number,
                  style: AppStyles.p1,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.6),
                  child: Image.asset(
                    img,
                    height: 50,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
