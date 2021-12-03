import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ContainerWithPromocode extends StatelessWidget {
  const ContainerWithPromocode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteRoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '6СС5165АDF345',
            style: AppStyles.h2,
          ),
          const SizedBox(
            width: 9,
          ),
          Image.asset(
            'assets/copy.png',
            height: 15,
          ),
        ],
      ),
    );
  }
}
