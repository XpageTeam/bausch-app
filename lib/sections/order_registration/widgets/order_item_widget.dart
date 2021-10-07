import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/point_widget.dart';
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
                      style: AppStyles.h2Bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  if (points != '')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            points,
                            style: AppStyles.h2Bold,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const PointWidget(),
                      ],
                    ),
                ],
              ),
            ),
            Image.asset(
              'assets/items/item1.png',
              scale: 3,
            )
          ],
        ),
      ),
    );
  }
}
