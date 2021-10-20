part of 'shop_filter_bloc.dart';

@immutable
abstract class ShopFilterState {
  final List<String> selectedFilters;
  const ShopFilterState({
    required this.selectedFilters,
  });
}

class ShopFilterInitial extends ShopFilterState {
  ShopFilterInitial({
    required String defaultFilter,
  }) : super(
          selectedFilters: [defaultFilter],
        );
}

class ShopFilterChange extends ShopFilterState {
  const ShopFilterChange({
    required List<String> selectedFilters,
  }) : super(
          selectedFilters: selectedFilters,
        );
}

// TODO(Nikolay): по-сути костыль.
class ShopFilterAccept extends ShopFilterState {
  const ShopFilterAccept({
    required List<String> selectedFilters,
  }) : super(
          selectedFilters: selectedFilters,
        );
}

class ShopFilterClear extends ShopFilterState {
  const ShopFilterClear({
    required List<String> selectedFilters,
  }) : super(
          selectedFilters: selectedFilters,
        );
}
