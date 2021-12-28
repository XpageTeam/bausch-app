import 'dart:ui';

import 'package:bausch/global/user/user_wm.dart';
import 'package:bausch/repositories/user/user_repository.dart';
import 'package:bausch/sections/profile/content/scrollable_profile_content.dart';
import 'package:bausch/sections/profile/profile_app_bar.dart';
import 'package:bausch/sections/profile/profile_screen_wm.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/appbar/empty_appbar.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ProfileScreen extends CoreMwwmWidget<ProfileScreenWM> {
  ProfileScreen({Key? key})
      : super(
          key: key,
          widgetModelBuilder: (_) => ProfileScreenWM(),
        );

  @override
  WidgetState<CoreMwwmWidget<ProfileScreenWM>, ProfileScreenWM>
      createWidgetState() => _ProfileScreenState();
}

class _ProfileScreenState extends WidgetState<ProfileScreen, ProfileScreenWM> {
  final profileAppBarHeight =
      58.0; //  это высота ProfileAppBar (56) + высота отступа (это в ProfileAppBar) сверху (2)
  final imageHeight = 220.0;
  final sizedBoxHeight = 17.0;

  late UserWM userWM;

  late double minChildSize;
  late double maxChildSize;

  @override
  void initState() {
    super.initState();
    minChildSize = _calcMinChildSize();
    maxChildSize = _calcMaxChildSize();
  }

  @override
  Widget build(BuildContext context) {
    userWM = Provider.of<UserWM>(context);

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
                        streamedState: userWM.userData,
                        builder: (_, userRepo) {
                          return Text(
                            userRepo.userName,
                            style: AppStyles.h1,
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
                        height: sizedBoxHeight,
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
                                      height: imageHeight,
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
                  minChildSize: minChildSize,
                  maxChildSize: maxChildSize,
                  initialChildSize: minChildSize,
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
        bottomSheet: const SizedBox(height: 60, child: InfoBlock()),
        extendBodyBehindAppBar: true,
      ),
    );
  }

  double _calcMinChildSize() {
    return 1 -
        (imageHeight / 2 + sizedBoxHeight + profileAppBarHeight) /
            MediaQuery.of(context).size.height;
  }

  double _calcMaxChildSize() {
    return 1 -
        profileAppBarHeight /
            (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom);
  }
}
