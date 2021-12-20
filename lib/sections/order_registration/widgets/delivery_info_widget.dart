import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/text/bulleted_list.dart';
import 'package:flutter/material.dart';

class DeliveryInfoWidget extends StatelessWidget {
  const DeliveryInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BulletedList(
      list: StaticData.deliveryInfoStrings,
    );
  }
}
