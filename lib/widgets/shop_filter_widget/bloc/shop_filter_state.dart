part of 'shop_filter_bloc.dart';

@immutable
abstract class ShopFilterState {
  final List<Filter> selectedFilters;
  const ShopFilterState({
    required this.selectedFilters,
  });
}

class ShopFilterInitial extends ShopFilterState {
  ShopFilterInitial({
    required Filter defaultFilter,
  }) : super(
          selectedFilters: [defaultFilter],
        );
}

class ShopFilterChange extends ShopFilterState {
  const ShopFilterChange({
    required List<Filter> selectedFilters,
  }) : super(
          selectedFilters: selectedFilters,
        );
}

class ShopFilterClear extends ShopFilterState {
  const ShopFilterClear({
    required List<Filter> selectedFilters,
  }) : super(
          selectedFilters: selectedFilters,
        );
}
