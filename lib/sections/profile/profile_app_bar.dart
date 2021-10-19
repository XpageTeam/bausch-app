import 'package:bausch/sections/profile/profile_settings/profile_settings_screen.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          left: StaticData.sidePadding,
          right: StaticData.sidePadding,
          top: 2,
        ),
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NormalIconButton(
                onPressed: () {
                  Keys.mainContentNav.currentState!.pop();
                }, //Navigator.of(context).pop,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  size: 20,
                  color: AppTheme.mineShaft,
                ),
              ),
              NormalIconButton(
                onPressed: () {
                  Keys.mainContentNav.currentState!
                      .pushNamed('/profile_settings');
                }, //Navigator.of(context).pop,
                icon: const Icon(
                  Icons.settings,
                  size: 20,
                  color: AppTheme.mineShaft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
