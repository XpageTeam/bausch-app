import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
import 'package:bausch/widgets/shop_filter_widget/shop_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopFilterWidget extends StatefulWidget {
  final List<String> btnTexts;
  const ShopFilterWidget({
    required this.btnTexts,
    Key? key,
  }) : super(key: key);

  @override
  _ShopFilterWidgetState createState() => _ShopFilterWidgetState();
}

class _ShopFilterWidgetState extends State<ShopFilterWidget> {
  Set<String> selectedFilters = <String>{};
  late ShopFilterBloc filterBloc;

  @override
  void initState() {
    super.initState();
    filterBloc = BlocProvider.of<ShopFilterBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: BlocBuilder<ShopFilterBloc, ShopFilterState>(
        builder: (context, state) {
          return Row(
            children: widget.btnTexts
                .map(
                  (filter) => ShopFilterButton(
                    title: filter,
                    isSelected: state.selectedFilters.contains(filter),
                    onPressed: () => widget.btnTexts.first == filter
                        ? removeFilters()
                        : changeFiltersWith(filter),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
    // return SizedBox(
    //   height: 40,
    //   child: CustomScrollView(
    //     physics: const BouncingScrollPhysics(),
    //     scrollDirection: Axis.horizontal,
    //     slivers: [
    //       SliverPadding(
    //         padding: const EdgeInsets.symmetric(
    //           horizontal: StaticData.sidePadding,
    //         ),
    //         sliver: BlocBuilder<ShopFilterBloc, ShopFilterState>(
    //           builder: (context, state) {
    //             return SliverList(
    //               delegate: SliverChildBuilderDelegate(
    // (context, i) => ShopFilterButton(
    //   title: widget.btnTexts[i],
    //   isSelected:
    //       state.selectedFilters.contains(widget.btnTexts[i]),
    //   onPressed: () => i == 0
    //       ? removeFilters()
    //       : changeFiltersBy(widget.btnTexts[i]),
    // ),
    //                 childCount: widget.btnTexts.length,
    //               ),
    //             );
    //           },
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }

  void removeFilters() {
    filterBloc.add(
      ShopFilterClearEvent(
        defaultFilter: widget.btnTexts[0],
      ),
    );
  }

  void changeFiltersWith(String filter) {
    filterBloc.add(
      ShopFilterChangeEvent(filter: filter),
    );
  }
}
