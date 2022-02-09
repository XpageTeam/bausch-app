import 'package:bausch/sections/home/widgets/simple_slider/wm/simple_slider_wm.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:bausch/widgets/catalog_item/catalog_item.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

typedef ItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
);

class SimpleSlider<T> extends CoreMwwmWidget<SimpleSliderWM> {
  final List<T> items;
  final ItemBuilder<T> builder;

  SimpleSlider({
    required this.items,
    required this.builder,
    Key? key,
  }) : super(key: key, widgetModelBuilder: (context) => SimpleSliderWM());

  @override
  WidgetState<CoreMwwmWidget<SimpleSliderWM>, SimpleSliderWM>
      createWidgetState() => _SlimpleSliderState<T>();
}

class _SlimpleSliderState<T>
    extends WidgetState<SimpleSlider<T>, SimpleSliderWM> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            final width =
                notification.metrics.maxScrollExtent / widget.items.length;
            final position = ((notification.metrics.maxScrollExtent -
                            notification.metrics.extentAfter) /
                        width)
                    .round() -
                1;

            if (position >= 0) {
              if ((position / 2).ceil() <=
                  (widget.items.length / 2).ceil() - 1) {
                wm.lastItemState.accept((position / 2).ceil());
              }
            }
            return true;
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            child: IntrinsicHeight(
              child: Row(
                children: List.generate(
                  widget.items.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right: index == widget.items.length - 1 ? 0 : 4,
                    ),
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width / 2 -
                            StaticData.sidePadding -
                            2,
                      ),
                      child: widget.builder(
                        context,
                        widget.items[index],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        StreamedStateBuilder<int>(
          streamedState: wm.lastItemState,
          builder: (_, position) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                (widget.items.length / 2).ceil(),
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: index != widget.items.length ? 4 : 0,
                  ),
                  child: Container(
                    height: 4,
                    width: (MediaQuery.of(context).size.width -
                            101 * 2 -
                            4 * (widget.items.length - 1)) /
                        widget.items.length,
                    color: index == position
                        ? AppTheme.turquoiseBlue
                        : Colors.white,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
