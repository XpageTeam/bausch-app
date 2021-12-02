
import 'package:bausch/sections/profile/bloc/opacity_bloc.dart';
import 'package:bausch/sections/profile/notification_listener.dart';
import 'package:bausch/sections/profile/profile_app_bar.dart';
import 'package:bausch/sections/profile/scrollable_profile_content.dart';
import 'package:bausch/sections/profile/user_status_name.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpacityBloc(minChildSize: 0.7),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body: SizedBox.expand(
          child: Builder(
            builder: (context) => CustomNotificationListener(
              child: Stack(
                children: [
                  const ProfileAppBar(),

                  //* Фон со статусом и именем пользователя
                  const UserStatusName(),

                  //* Слайдер, наезжающий на фон
                  DraggableScrollableSheet(
                    minChildSize: 0.7,
                    maxChildSize: 0.89,
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
            ),
          ),
        ),
        bottomSheet: const InfoBlock(),
      ),
    );
  }
}
