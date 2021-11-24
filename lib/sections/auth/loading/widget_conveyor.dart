import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class WidgetConveyor extends StatefulWidget {
  final int duration;
  final List<Widget> children;
  const WidgetConveyor({
    required this.duration,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  _WidgetConveyorState createState() => _WidgetConveyorState();
}

class _WidgetConveyorState extends State<WidgetConveyor> with AfterLayoutMixin {
  // late AnimationController _controller;
  // late Animation<double> _moveAnimation;

  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    // _controller = AnimationController(
    //   vsync: this,
    //   duration: Duration(
    //     seconds: widget.duration,
    //   ),
    // )..repeat();

    // _moveAnimation = Tween<double>(begin: 0.0, end: 1416).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.children,
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(seconds: 25),
          curve: Curves.linear,
        );
      }
    });

    controller.addListener(() {
      if (controller.offset == controller.position.maxScrollExtent) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          controller
            ..jumpTo(0)
            ..animateTo(
              controller.position.maxScrollExtent,
              duration: const Duration(seconds: 25),
              curve: Curves.linear,
            );
        });
      }

      // if (controller.offset == 0) {
      //   WidgetsBinding.instance?.addPostFrameCallback((_) {
      //     controller.animateTo(
      //       controller.position.maxScrollExtent,
      //       duration: const Duration(seconds: 25),
      //       curve: Curves.linear,
      //     );
      //   });
      // }
    });
  }
}

// Timer(
//           const Duration(microseconds: 1),
          // () => controller.animateTo(
          //   controller.position.maxScrollExtent,
          //   duration: const Duration(seconds: 25),
          //   curve: Curves.linear,
          // ),
//         );
