import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/widgets/shop_filter_widget/bloc/shop_filter_bloc.dart';
import 'package:bausch/widgets/shop_filter_widget/shop_filter_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopFilterWidget extends StatelessWidget {
  final List<Filter> filterList;
  const ShopFilterWidget({
    required this.filterList,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: BlocBuilder<ShopFilterBloc, ShopFilterState>(
        builder: (context, state) {
          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, i) => ShopFilterButton(
              title: filterList[i].title,
              isSelected: state.selectedFilters.contains(filterList[i]),
              onPressed: () => filterList.first == filterList[i]
                  ? BlocProvider.of<ShopFilterBloc>(context).add(
                      ShopFilterClearEvent(
                        defaultFilter: filterList[0],
                      ),
                    )
                  : BlocProvider.of<ShopFilterBloc>(context).add(
                      ShopFilterChangeEvent(
                        filter: filterList[i],
                      ),
                    ),
            ),
            separatorBuilder: (context, i) => const SizedBox(
              width: 4,
            ),
            itemCount: filterList.length,
          );
        },
      ),
    );
  }
}
