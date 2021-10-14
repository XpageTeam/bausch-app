import 'package:bausch/sections/order_registration/widgets/marked_text_row.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';

class DeliveryInfoWidget extends StatelessWidget {
  const DeliveryInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => MarkedTextRow(
        text: StaticData.deliveryInfoStrings[index],
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemCount: StaticData.deliveryInfoStrings.length,
    );
  }
}
