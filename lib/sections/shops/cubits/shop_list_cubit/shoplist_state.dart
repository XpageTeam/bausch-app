part of 'shoplist_cubit.dart';

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
  final List<CityModel> cityList;

  const ShopListSuccess({
    required this.cityList,
  });
}
class ShopListEmpty extends ShopListState {
   const ShopListEmpty();
}
