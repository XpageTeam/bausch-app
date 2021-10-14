import 'package:bausch/sections/profile/profile_background.dart';
import 'package:bausch/sections/profile/profile_settings/profile_settings_screen.dart';
import 'package:bausch/sections/profile/scrollable_profile_content.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.turquoiseBlue,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
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
                      onPressed: () {}, //Navigator.of(context).pop,
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        size: 20,
                        color: AppTheme.mineShaft,
                      ),
                    ),
                    NormalIconButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ProfileSettingsScreen();
                            },
                          ),
                        );
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
            const ProfileBackground(),
            DraggableScrollableSheet(
              minChildSize: 0.7,
              maxChildSize: 0.9,
              initialChildSize: 0.7,
              builder: (context, controller) {
                return Container(
                  color: AppTheme.mystic,
                  child: ScrollableProfileContent(
                    controller: controller,
                  ),
                );
              },
            ),
          ],
        ),
      ),
      // Todo(Nikita): Вывести InfoWidget
      // ignore: avoid_redundant_argument_values
      floatingActionButton: null,
    );
  }
}
