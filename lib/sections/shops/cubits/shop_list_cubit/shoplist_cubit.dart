import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'shoplist_state.dart';

class ShopListCubit extends Cubit<ShopListState> {
  ShopListCubit() : super(ShopListInitial());

  Future<void> loadShopList() async {
    emit(ShopListLoading());
    emit(await _loadShopList());
  }

  Future<void> loadShopListByCity(String city) async {
    emit(ShopListLoading());
    emit(await _loadShopListByCity(city));
  }

  Future<ShopListState> _loadShopList() async {
    try {
      final citiesRepository = await CitiesWithShopsDownloader.load();
      return ShopListSuccess(
        shopList: citiesRepository.shopList,
      );
    } on DioError catch (e) {
      return ShopListFailed(
        title: 'Problems???? (интернет)',
        text: e.message,
      );
    } on ResponseParseException catch (e) {
      return ShopListFailed(
        title: 'Problems???? (парсинг)',
        text: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return ShopListFailed(
        title: 'Problems???? (суксес фолс)',
        text: e.toString(),
      );
    }
  }

  Future<ShopListState> _loadShopListByCity(String city) async {
    try {
      final citiesRepository = await CitiesWithShopsDownloader.load();
      return ShopListSuccess(
        shopList: citiesRepository.getShopListByCity(city),
      );
    } on DioError catch (e) {
      return ShopListFailed(
        title: 'Problems???? (интернет)',
        text: e.message,
      );
    } on ResponseParseException catch (e) {
      return ShopListFailed(
        title: 'Problems???? (парсинг)',
        text: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return ShopListFailed(
        title: 'Problems???? (суксес фолс)',
        text: e.toString(),
      );
    }
  }
}
