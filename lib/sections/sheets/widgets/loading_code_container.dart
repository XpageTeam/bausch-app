import 'package:bausch/sections/sheets/white_rounded_container.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/loader/ui_loader.dart';
import 'package:flutter/material.dart';

class LoadingCodeContainer extends StatelessWidget {
  final String text;
  const LoadingCodeContainer({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WhiteRoundedContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: const [
              UiCircleLoader(),
              SizedBox(
                width: 9,
              ),
            ],
          ),
          Flexible(
            child: Text(
              text,
              style: AppStyles.h2,
            ),
          ),
        ],
      ),
    );
  }
}
