import 'package:bausch/sections/profile/profile_app_bar.dart';
import 'package:bausch/sections/profile/profile_background.dart';
import 'package:bausch/sections/profile/scrollable_profile_content.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.turquoiseBlue,
      body: Stack(
        children: [
          const ProfileAppBar(),

          //* Фон со статусом и именем пользователя
          const ProfileBackground(),

          //* Слайдер, наезжающий на фон
          DraggableScrollableSheet(
            minChildSize: 0.7,
            maxChildSize: 0.9,
            initialChildSize: 0.7,
            builder: (context, controller) {
              return Container(
                color: AppTheme.mystic,

                //* Контент слайдера(заказы, уведомления)
                child: ScrollableProfileContent(
                  controller: controller,
                ),
              );
            },
          ),
        ],
      ),
      bottomSheet: const InfoBlock(),
    );
  }
}
