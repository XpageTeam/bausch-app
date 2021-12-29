import 'package:flutter/material.dart';

class CustomSheetScaffold extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> slivers;
  final Widget? bottomNavBar;
  final Widget? floatingActionButton;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  //final bool withAppBar;
  final Widget? appBar;
  const CustomSheetScaffold({
    required this.controller,
    required this.slivers,
    this.resizeToAvoidBottomInset = true,
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
            CustomScrollView(
              controller: controller,
              slivers: slivers,
              physics: const BouncingScrollPhysics(),
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
        bottomNavigationBar: bottomNavBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
