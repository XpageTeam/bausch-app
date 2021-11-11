part of 'catalog_item_cubit.dart';

@immutable
abstract class CatalogItemState {}

class CatalogItemInitial extends CatalogItemState {}

class CatalogItemLoading extends CatalogItemState {}

class CatalogItemSuccess extends CatalogItemState {
  final List<CatalogItemModel> items;

  CatalogItemSuccess({required this.items});
}

class CatalogItemFailed extends CatalogItemState {
  final String title;
  final String? subtitle;

  CatalogItemFailed({
    required this.title,
    this.subtitle,
  });
}
