import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/widgets/shop_filter_widget/shop_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:surf_mwwm/surf_mwwm.dart';

// TODO(Nikolay): Переделать.
class ShopFilter extends CoreMwwmWidget<ShopFilterWM> {
  ShopFilter({
    required List<Filter> filters,
    required void Function(List<Filter> selectedFilters) callback,
    Key? key,
  }) : super(
          key: key,
          widgetModelBuilder: (_) => ShopFilterWM(
            filters: filters,
            callback: callback,
          ),
        );

  @override
  WidgetState<CoreMwwmWidget<ShopFilterWM>, ShopFilterWM> createWidgetState() =>
      _ShopFilterState();
}

class _ShopFilterState extends WidgetState<ShopFilter, ShopFilterWM> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: StreamedStateBuilder<List<Filter>>(
        streamedState: wm.selectedFilters,
        builder: (_, selectedFilters) => ListView.separated(
          itemBuilder: (_, i) => ShopFilterButton(
            filter: wm.filters[i],
            onPressed: wm.selectFilter,
          ),
          separatorBuilder: (_, i) => const SizedBox(
            width: 4,
          ),
          itemCount: wm.filters.length,
        ),
      ),

      // BlocBuilder<ShopFilterBloc, ShopFilterState>(
      //   builder: (context, state) {
      //     return ListView.separated(
      //       physics: const BouncingScrollPhysics(),
      //       scrollDirection: Axis.horizontal,
      //       itemBuilder: (context, i) => ShopFilterButton(
      //         title: widget.filterList[i].title,
      //         isSelected: state.selectedFilters.contains(widget.filterList[i]),
      //         onPressed: () => widget.filterList.first == widget.filterList[i]
      //             ? BlocProvider.of<ShopFilterBloc>(context).add(
      //                 ShopFilterClearEvent(
      //                   defaultFilter: widget.filterList[0],
      //                 ),
      //               )
      //             : BlocProvider.of<ShopFilterBloc>(context).add(
      //                 ShopFilterChangeEvent(
      //                   filter: widget.filterList[i],
      //                 ),
      //               ),
      //       ),
      //       separatorBuilder: (context, i) => const SizedBox(
      //         width: 4,
      //       ),
      //       itemCount: widget.filterList.length,
      //     );
      //   },
      // ),
    );
  }
}

class ShopFilterWM extends WidgetModel {
  final List<Filter> filters;
  final void Function(List<Filter> selectedFilters) callback;

  late final selectedFilters = StreamedState<List<Filter>>([filters.first]);

  final selectFilter = StreamedAction<Filter>();

  ShopFilterWM({
    required this.filters,
    required this.callback,
  }) : super(
          const WidgetModelDependencies(),
        );

  @override
  void onBind() {
    selectFilter.bind(_selectFilter);

    super.onBind();
  }

  void _selectFilter(Filter? filter) {
    // TODO(Nikolay): Доделать выбор фильтра.
    final contains = selectedFilters.value.any((element) => element == filter);

    if (contains) {
      selectedFilters.accept(
        selectedFilters.value
          ..removeWhere(
            (element) => element == filter,
          ),
      );
    } else {
      selectedFilters.accept(
        selectedFilters.value..add(filter!),
      );
    }

    callback(selectedFilters.value);
  }
}
