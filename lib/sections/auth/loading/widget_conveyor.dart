import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';

class WidgetConveyor extends StatefulWidget {
  final List<Widget> children;
  const WidgetConveyor({
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  _WidgetConveyorState createState() => _WidgetConveyorState();
}

class _WidgetConveyorState extends State<WidgetConveyor> with AfterLayoutMixin {
  final ScrollController controller = ScrollController();

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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller
            ..jumpTo(0)
            ..animateTo(
              controller.position.maxScrollExtent,
              duration: const Duration(seconds: 25),
              curve: Curves.linear,
            );
        });
      }
    });
  }
}
