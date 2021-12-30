import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/sections/select_optic/widgets/shop_filter_widget/shop_filter_button.dart';
import 'package:bausch/sections/select_optic/widgets/shop_filter_widget/widget_model/shop_filter_wm.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

class ShopFilterWidget extends CoreMwwmWidget<ShopFilterWM> {
  final List<Filter> filters;
  ShopFilterWidget({
    required this.filters,
    required void Function(List<Filter> selectedFilters) callback,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => ShopFilterWM(
            initialFilters: filters,
            callback: callback,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<ShopFilterWM>, ShopFilterWM> createWidgetState() =>
      _ShopFilterState();
}

class _ShopFilterState extends WidgetState<ShopFilterWidget, ShopFilterWM> {
  @override
  void didUpdateWidget(covariant ShopFilterWidget oldWidget) {
    wm.updateFilters(widget.filters);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: StreamedStateBuilder<List<Filter>>(
          streamedState: wm.filtersStreamed,
          builder: (_, filters) => Row(
            children: List.generate(
              filters.length,
              (i) => Padding(
                padding: EdgeInsets.only(
                  right: filters.length - 1 == i ? 0 : 4,
                ),
                child: ShopFilterButton(
                  isSelected: wm.selectedFilters.any(
                    (filter) => filter.title == filters[i].title,
                  ),
                  filter: filters[i],
                  onPressed: wm.selectFilter,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
