import 'dart:ui';

import 'package:bausch/main.dart';
import 'package:bausch/sections/profile/bloc/opacity_bloc.dart';
import 'package:bausch/sections/profile/notification_listener.dart';
import 'package:bausch/sections/profile/profile_app_bar.dart';
import 'package:bausch/sections/profile/scrollable_profile_content.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/theme/styles.dart';
import 'package:bausch/widgets/bottom_info_block.dart';
import 'package:bausch/widgets/buttons/normal_icon_button.dart';
import 'package:bausch/widgets/default_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpacityBloc(minChildSize: 0.7),
      child: Scaffold(
        backgroundColor: AppTheme.mystic,
        body:
            // SizedBox.expand(
            //   child: Builder(
            //     builder: (context) => CustomNotificationListener(
            //       child:
            CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              delegate: MySliverAppBar(
                expandedHeight: 200,
                topHeigh: MediaQuery.of(context).padding.top,
              ),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, index) => const ListTile(
                  title: Text("Index: 1"),
                ),
              ),
            ),
          ],
        ),
        //  Stack(
        //   children: [
        //     const ProfileAppBar(),

        //     //* Фон со статусом и именем пользователя
        //     SafeArea(
        //       child: Padding(
        //         padding: const EdgeInsets.only(
        //           top: 10,
        //         ),
        //         child: Column(
        //           children: [
        //             const Text(
        //               'Саша',
        //               style: AppStyles.h1,
        //             ),
        //             BlocBuilder<OpacityBloc, double>(
        //               builder: (context, opacity) {
        //                 return AnimatedOpacity(
        //                   opacity: 1 - opacity,
        //                   duration: const Duration(milliseconds: 100),
        //                   child: Container(
        //                     padding: const EdgeInsets.symmetric(
        //                       horizontal: 6,
        //                       vertical: 4,
        //                     ),
        //                     decoration: BoxDecoration(
        //                       borderRadius: BorderRadius.circular(5),
        //                       color: AppTheme.sulu,
        //                     ),
        //                     child: const Text(
        //                       'Классный друг',
        //                       style: AppStyles.h1,
        //                     ),
        //                   ),
        //                 );
        //               },
        //             ),
        //             const SizedBox(
        //               height: 17,
        //             ),
        // Center(
        //   child: Stack(
        //     alignment: Alignment.center,
        //     children: [
        //       Image.asset(
        //         'assets/status.png',
        //         width: 200,
        //       ),
        //       SizedBox(
        //         height: 50,
        //         child: ClipRRect(
        //           child: BackdropFilter(
        //             filter: ImageFilter.blur(
        //               sigmaX: 20,
        //               sigmaY: 20,
        //             ),
        //             child: Container(
        //               color: AppTheme.turquoiseBlue
        //                   .withOpacity(0.3),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        //           ],
        //         ),
        //       ),
        //     ),

        //     //* Слайдер, наезжающий на фон
        //     DraggableScrollableSheet(
        //       minChildSize: 0.7,
        //       maxChildSize: 0.89,
        //       initialChildSize: 0.7,
        //       builder: (context, controller) {
        //         return Container(
        //           color: AppTheme.mystic,

        //           //* Контент слайдера(заказы, уведомления)
        //           child: ScrollableProfileContent(
        //             controller: controller,
        //           ),
        //         );
        //       },
        //     ),
        //   ],
        // ),
        //     ),
        //   ),
        // ),
        bottomSheet: const InfoBlock(),
      ),
    );
  }
}

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double topHeigh;
  @override
  double get maxExtent => topHeigh + expandedHeight;

  @override
  double get minExtent => topHeigh + 48;

  MySliverAppBar({
    required this.expandedHeight,
    required this.topHeigh,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SafeArea(
      child: Container(
        color: AppTheme.turquoiseBlue,
        child: Stack(
          // fit: StackFit.expand,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 2,
                left: StaticData.sidePadding,
                right: StaticData.sidePadding,
              ),
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  NormalIconButton(
                    icon: Icon(Icons.chevron_left),
                  ),
                  NormalIconButton(
                    icon: Icon(Icons.settings),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10),
              alignment: Alignment.topCenter,
              child: const Text(
                'Саша',
                style: AppStyles.h1,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: shrinkOffset / expandedHeight),
              child: Opacity(
                opacity: 1 - shrinkOffset / expandedHeight < 0
                    ? 0
                    : 1 - shrinkOffset / expandedHeight,
                child: const RankWidget(title: 'Классный друг'),
              ),
            ),
            Positioned(
              top: expandedHeight / 2,
              left: 0,
              right: 0,
              child: const BluredImage(),
            ),

            // Stack(
            //   alignment: Alignment.center,
            //   children: [
            // Image.asset(
            //   'assets/status.png',
            //   width: 200,
            // ),
            //     SizedBox(
            //       height: 50,
            //       child: ClipRRect(
            //         child: BackdropFilter(
            //           filter: ImageFilter.blur(
            //             sigmaX: 20,
            //             sigmaY: 20,
            //           ),
            //           child: Container(
            //             color: AppTheme.turquoiseBlue.withOpacity(0.3),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),

            // Image.network(
            //   "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
            //   fit: BoxFit.cover,
            // ),

            // Container(
            //   alignment: Alignment.center,
            //   color: Colors.white,
            //   child: Opacity(
            //     opacity: 1, //shrinkOffset / expandedHeight,
            //     child: const Text(
            //       'MySliverAppBar',
            //       style: TextStyle(
            //         color: AppTheme.sulu,
            //         fontWeight: FontWeight.w700,
            //         fontSize: 23,
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   top: expandedHeight / 2 - shrinkOffset,
            //   left: MediaQuery.of(context).size.width / 4,
            //   child: Opacity(
            //     opacity: 1 - shrinkOffset / expandedHeight,
            //     child: Card(
            //       elevation: 10,
            //       child: SizedBox(
            //         height: expandedHeight,
            //         width: MediaQuery.of(context).size.width / 2,
            //         child: FlutterLogo(),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
