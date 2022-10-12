import 'package:bausch/sections/sheets/other_draggable_scrollable_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BottomSheetPage extends StatefulWidget {
  final OtherDraggableScrollableController? draggableScrollableController;
  final VoidCallback? onPop;

  final Widget Function(
    BuildContext context,
    ScrollController controller,
  ) builder;
  const BottomSheetPage({
    required this.builder,
    this.draggableScrollableController,
    this.onPop,
    super.key,
  });

  @override
  State<BottomSheetPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<BottomSheetPage> {
  bool isClosing = false;
  @override
  void initState() {
    super.initState();
    widget.draggableScrollableController?.addListener(_dragListener);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      widget.draggableScrollableController?.animateTo(
        0.95,
        duration: const Duration(
          milliseconds: 200,
        ),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    widget.draggableScrollableController?.removeListener(_dragListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: widget.onPop ?? Navigator.of(context).pop,
          child: SizedBox.expand(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              color: isClosing
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.8),
            ),
          ),
        ),
        OtherDraggableScrollableSheet(
          controller: widget.draggableScrollableController,
          initialChildSize: 0.05,
          maxChildSize: 0.95,
          minChildSize: 0,
          snap: true,
          snapSizes: const [0, 0.4, 0.95],
          builder: widget.builder,
        ),
      ],
    );
  }

  void _dragListener() {
    if (widget.draggableScrollableController!.size < 0.05 && !isClosing) {
      setState(() {
        isClosing = true;
      });
    }
  }
}
