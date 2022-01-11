import 'package:bausch/help/utils.dart';
import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class ContainerWithPromocode extends StatelessWidget {
  final String promocode;
  final bool withIcon;
  final VoidCallback? onPressed;

  const ContainerWithPromocode({
    required this.promocode,
    this.withIcon = true,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed ?? () => Utils.copyStringToClipboard(promocode),
      child: WhiteRoundedContainer(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              promocode,
              style: AppStyles.h2,
            ),
            if (withIcon == true)
              Row(
                children: [
                  const SizedBox(
                    width: 9,
                  ),
                  Image.asset(
                    'assets/copy.png',
                    height: 15,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
