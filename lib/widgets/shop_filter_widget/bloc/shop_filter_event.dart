part of 'shop_filter_bloc.dart';

@immutable
abstract class ShopFilterEvent {
  const ShopFilterEvent();
}

class ShopFilterChangeEvent extends ShopFilterEvent {
  final String filter;
  const ShopFilterChangeEvent({
    required this.filter,
  });
}

class ShopFilterClearEvent extends ShopFilterEvent {
  final String? defaultFilter;
  const ShopFilterClearEvent({this.defaultFilter});
}
