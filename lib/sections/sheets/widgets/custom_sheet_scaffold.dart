import 'package:flutter/material.dart';

class CustomSheetScaffold extends StatelessWidget {
  final ScrollController controller;
  final List<Widget> slivers;
  final Widget? bottomButton;
  final Color? backgroundColor;
  //final bool withAppBar;
  final Widget? appBar;
  const CustomSheetScaffold({
    required this.controller,
    required this.slivers,
    this.appBar,
    this.bottomButton,
    this.backgroundColor,
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
        bottomNavigationBar: bottomButton,
      ),
    );
  }
}
