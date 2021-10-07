import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomSliverAppbar extends StatelessWidget {
  const CustomSliverAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                Utils.bottomSheetNav.currentState!.pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppTheme.mineShaft,
              ),
            ),
          ),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                Utils.mainAppNav.currentState!.pop();
              },
              icon: const Icon(
                Icons.close,
                color: AppTheme.mineShaft,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
