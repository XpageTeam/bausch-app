import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/text/text_with_point.dart';
import 'package:flutter/material.dart';

class DeliveryInfoWidget extends StatelessWidget {
  const DeliveryInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => TextWithPoint(
        text: StaticData.deliveryInfoStrings[index],
        dotStyle: AppStyles.p1,
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: StaticData.deliveryInfoStrings.length,
    );
  }
}
