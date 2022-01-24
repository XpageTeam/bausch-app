import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CustomSheetScaffold extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> slivers;
  final Widget? bottomNavBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  //final bool withAppBar;
  final Widget? appBar;

  final bool hideBottomNavBarThenKeyboard;
  final ValueChanged<double>? onScrolled;

  const CustomSheetScaffold({
    required this.controller,
    required this.slivers,
    this.onScrolled,
    this.resizeToAvoidBottomInset = true,
    this.hideBottomNavBarThenKeyboard = false,
    this.appBar,
    this.bottomNavBar,
    this.backgroundColor,
    this.floatingActionButton,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(5),
        topRight: Radius.circular(5),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (onScrolled != null) {
                  onScrolled!(notification.metrics.pixels);
                }
                return true;
              },
              child: CustomScrollView(
                controller: controller,
                slivers: slivers
                  ..add(
                    SliverList(
                      delegate: SliverChildListDelegate([
                        if (hideBottomNavBarThenKeyboard)
                          KeyboardVisibilityBuilder(
                            builder: (p0, isKeyboardVisible) {
                              if (isKeyboardVisible) {
                                return bottomNavBar ?? const SizedBox();
                              }

                              return const SizedBox();
                            },
                          ),
                      ]),
                    ),
                  ),
                physics: const BouncingScrollPhysics(),
              ),
            ),
            if (appBar != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: appBar!,
              ),
          ],
        ),
        bottomNavigationBar: KeyboardVisibilityBuilder(
          builder: (p0, isKeyboardVisible) {
            if (!isKeyboardVisible || !hideBottomNavBarThenKeyboard) {
              return bottomNavBar ?? const SizedBox();
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
