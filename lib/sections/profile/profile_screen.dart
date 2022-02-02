import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/profile/content/scrollable_profile_content.dart';
import 'package:bausch/sections/profile/profile_app_bar.dart';
import 'package:bausch/sections/profile/profile_screen_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileScreen extends CoreMwwmWidget<ProfileScreenWM> {
  ProfileScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (context) => ProfileScreenWM(context: context),
        );

  @override
  WidgetState<CoreMwwmWidget<ProfileScreenWM>, ProfileScreenWM>
      createWidgetState() => _ProfileScreenState();
}

class _ProfileScreenState extends WidgetState<ProfileScreen, ProfileScreenWM> {
  @override
  void didChangeDependencies() {
    wm.initDraggableChildSizes();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        wm.notificationStreamed(notification);
        return false;
      },
      child: Scaffold(
        appBar: const NewEmptyAppBar(
          scaffoldBgColor: Colors.white,
        ),
        backgroundColor: AppTheme.turquoiseBlue,
        body: SizedBox.expand(
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
                      EntityStateBuilder<UserRepository>(
                        streamedState: wm.userWM.userData,
                        builder: (_, userRepo) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 56, //* padding + размер кнопки
                            ),
                            child: AutoSizeText(
                              userRepo.userName,
                              style: AppStyles.h1,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                      ),
                      StreamedStateBuilder<double>(
                        streamedState: wm.opacityStreamed,
                        builder: (_, opacity) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Opacity(
                              // opacity: 1 - opacity,
                              opacity: 0,
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
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: wm.sizedBoxHeight,
                      ),
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            StreamedStateBuilder<double>(
                              streamedState: wm.opacityStreamed,
                              builder: (_, opacity) => Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Opacity(
                                    opacity: 1 - opacity,
                                    child: Image.asset(
                                      'assets/status.png',
                                      // width: 200,
                                      height: wm.imageHeight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 100,
                              child: ClipRRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 20,
                                    sigmaY: 20,
                                  ),
                                  child: Container(
                                    color:
                                        AppTheme.turquoiseBlue.withOpacity(0.3),
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

              SafeArea(
                child: DraggableScrollableSheet(
                  minChildSize: wm.minChildSize,
                  maxChildSize: wm.maxChildSize,
                  initialChildSize: wm.minChildSize,
                  snap: true,
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
              ),
            ],
          ),
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            InfoBlock(),
          ],
        ),
        extendBodyBehindAppBar: true,
      ),
    );
  }
}
