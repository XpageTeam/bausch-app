import 'dart:ui';

import 'package:bausch/sections/profile/bloc/opacity_bloc.dart';
import 'package:bausch/sections/profile/notification_listener.dart';
import 'package:bausch/sections/profile/profile_app_bar.dart';
import 'package:bausch/sections/profile/scrollable_profile_content.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
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
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Саша',
                            style: AppStyles.h1,
                          ),
                          BlocBuilder<OpacityBloc, double>(
                            builder: (context, opacity) {
                              return AnimatedOpacity(
                                opacity: 1 - opacity,
                                duration: const Duration(milliseconds: 100),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: AppTheme.sulu,
                                  ),
                                  child: Text(
                                    'Классный друг',
                                    style: AppStyles.h1,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/status.png',
                                  width: 200,
                                ),
                                SizedBox(
                                  height: 50,
                                  child: ClipRRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 20,
                                        sigmaY: 20,
                                      ),
                                      child: Container(
                                        color: AppTheme.turquoiseBlue
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

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
