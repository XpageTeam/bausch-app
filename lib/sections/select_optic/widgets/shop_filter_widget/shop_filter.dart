import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/select_optic/widgets/shop_filter_widget/shop_filter_button.dart';
import 'package:bausch/static/static_data.dart';
import 'package:bausch/widgets/anti_glow_behavior.dart';
import 'package:flutter/material.dart';

class ShopFilterWidget extends StatelessWidget {
  final List<Filter> filters;
  final List<Filter> selectedFilters;
  final void Function(Filter filter) onTap;

  const ShopFilterWidget({
    required this.filters,
    required this.selectedFilters,
    required this.onTap,
    Key? key,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScrollConfiguration(
          behavior: const AntiGlowBehavior(),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              children: List.generate(
                filters.length,
                (i) => Padding(
                  padding: EdgeInsets.only(
                    left: i == 0 ? StaticData.sidePadding : 0,
                    right: filters.length - 1 == i ? StaticData.sidePadding : 4,
                  ),
                  child: ShopFilterButton(
                    isSelected: selectedFilters.any(
                      (filter) => filter.title == filters[i].title,
                    ),
                    filter: filters[i],
                    onPressed: onTap,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// class ShopFilterWidget extends CoreMwwmWidget<ShopFilterWM> {
//   final List<Filter> filters;
//   ShopFilterWidget({
//     required this.filters,
//     required void Function(List<Filter> selectedFilters) callback,
//     Key? key,
//   }) : super(
//           key: key,
//           widgetModelBuilder: (_) => ShopFilterWM(
//             initialFilters: filters,
//             callback: callback,
//           ),
//         );

//   @override
//   WidgetState<CoreMwwmWidget<ShopFilterWM>, ShopFilterWM> createWidgetState() =>
//       _ShopFilterState();
// }

// class _ShopFilterState extends WidgetState<ShopFilterWidget, ShopFilterWM> {
//   @override
//   void didUpdateWidget(covariant ShopFilterWidget oldWidget) {
//     wm.updateFilters(widget.filters);
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           physics: const BouncingScrollPhysics(),
//           child: StreamedStateBuilder<List<Filter>>(
//             streamedState: wm.filtersStreamed,
//             builder: (_, filters) => Row(
//               children: List.generate(
//                 filters.length,
//                 (i) => Padding(
//                   padding: EdgeInsets.only(
//                     left: i == 0 ? StaticData.sidePadding : 0,
//                     right: filters.length - 1 == i ? StaticData.sidePadding : 4,
//                   ),
//                   child: ShopFilterButton(
//                     isSelected: wm.selectedFilters.any(
//                       (filter) => filter.title == filters[i].title,
//                     ),
//                     filter: filters[i],
//                     onPressed: wm.selectFilter,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
