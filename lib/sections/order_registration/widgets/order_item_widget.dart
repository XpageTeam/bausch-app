import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  final String title;
  final String points;
  final String? imgLink;
  const OrderItemWidget({
    required this.title,
    this.points = '',
    this.imgLink,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      style: AppStyles.h3,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          points,
                          style: AppStyles.h3,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Image.asset(
                        'assets/images/points.png',
                        scale: 3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Image.asset(
              'assets/images/pic_3.png',
              scale: 3,
            )
          ],
        ),
      ),
    );
  }
}
