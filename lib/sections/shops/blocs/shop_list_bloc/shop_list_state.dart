part of 'shop_list_bloc.dart';

@immutable
abstract class ShopListState {
  const ShopListState();
}

class ShopListInitial extends ShopListState {}

class ShopListLoading extends ShopListState {}

class ShopListFailed extends ShopListState {
  final String title;
  final String? text;
  final VoidCallback? btnAction;

  const ShopListFailed({
    required this.title,
    this.text,
    this.btnAction,
  });
}

class ShopListSuccess extends ShopListState {
  final List<ShopModel> shopList;

  const ShopListSuccess({required this.shopList});
}
