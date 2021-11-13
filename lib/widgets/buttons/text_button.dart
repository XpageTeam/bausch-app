import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  const CustomTextButton({
    required this.title,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return TextButton(
    //   onPressed: onPressed,
    //   style: TextButton.styleFrom(
    //     padding: EdgeInsets.zero,
    //   ),
    //   child:
    // Row(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       Text(
    //         title,
    //         style: AppStyles.h1,
    //       ),
    //       const SizedBox(
    //         width: 4,
    //       ),
    //       const Icon(
    //         Icons.arrow_forward_ios_sharp,
    //         color: AppTheme.mineShaft,
    //         size: 20,
    //       ),
    //     ],
    //   ),
    // );
    return InkWell(
      splashColor: AppTheme.turquoiseBlue,
      borderRadius: BorderRadius.circular(5),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12,
        ),
        child: Row(
          children: [
            Text(
              title,
              style: AppStyles.h1,
            ),
            const SizedBox(
              width: 4,
            ),
            const Icon(
              Icons.arrow_forward_ios_sharp,
              color: AppTheme.mineShaft,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
