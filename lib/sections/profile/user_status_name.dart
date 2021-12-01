import 'package:bausch/global/user/user_wm.dart';

import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/profile/bloc/opacity_bloc.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class UserStatusName extends StatelessWidget {
  const UserStatusName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ),
        child: Column(
          children: [
            EntityStateBuilder<UserRepository>(
              streamedState:
                  Provider.of<UserWM>(context, listen: true).userData,
              builder: (_, user) {
                return Text(
                  user.user.name ?? 'name',
                  style: AppStyles.h1,
                );
              },
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
                          color: AppTheme.turquoiseBlue.withOpacity(0.3),
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
    );
  }
}
