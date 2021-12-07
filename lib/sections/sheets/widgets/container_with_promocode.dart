import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ContainerWithPromocode extends StatelessWidget {
  final String promocode;
  const ContainerWithPromocode({
    required this.promocode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteRoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            promocode,
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
