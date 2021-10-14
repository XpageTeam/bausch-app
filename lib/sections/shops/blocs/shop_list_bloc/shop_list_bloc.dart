import 'package:bausch/models/shop/shop_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'shop_list_event.dart';
part 'shop_list_state.dart';

class ShopListBloc extends Bloc<ShopListEvent, ShopListState> {
  ShopListBloc() : super(ShopListInitial()) {
    on<ShopListEvent>(
      (event, emit) async {
        if (event is ShopsListLoad) {
          emit(ShopListLoading());

          emit(await _loadData());
        }
      },
    );
  }

  Future<ShopListState> _loadData() async {
    await Future<dynamic>.delayed(const Duration(seconds: 2));
    return ShopListSuccess(shopList: ShopModel.generate(4));
  }
}
