import 'package:bausch/models/shop/shop_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'shoplist_state.dart';

class ShopListCubit extends Cubit<ShopListState> {
  ShopListCubit() : super(ShopListInitial());

  Future<void> loadShopList() async {
    emit(ShopListLoading());
    emit(await _loadShopList());
  }

  Future<ShopListState> _loadShopList() async {
    await Future<dynamic>.delayed(const Duration(seconds: 2));
    return ShopListSuccess(
      shopList: ShopModel.generate(0),
    ); 
  }
}
