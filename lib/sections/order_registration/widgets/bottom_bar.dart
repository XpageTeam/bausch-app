import 'package:bausch/sections/order_registration/widgets/blue_button.dart';
import 'package:bausch/sections/order_registration/widgets/contraindication_info_widget.dart';
import 'package:bausch/static/static_data.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final List<Widget> children;
  final VoidCallback? onPressed;
  const BottomBar({
    required this.children,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: StaticData.sidePadding,
          ),
          child: BlueButton(
            children: children,
            onPressed: onPressed,
          ),
        ),

        //* Информационный виджет "Имеются противопоказания..."
        const ContraindicationsInfoWidget(),
      ],
    );
  }
}
