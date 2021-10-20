import 'package:bausch/models/shop/shop_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

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
      shopList: shopList, //ShopModel.generate(0),
    );
  }

  final shopList = [
    ShopModel(
        id: 0,
        coords: const Point(
          latitude: 55.158682,
          longitude: 61.410983,
        ),
        name: 'ЛинзСервис',
        address: 'address',
        phone: 'phone',
        site: 'hello.ru'),
    ShopModel(
      id: 0,
      coords: const Point(
        latitude: 55.160574,
        longitude: 61.362429,
      ),
      name: 'ЛинзСервис',
      address: 'address',
      phone: 'phone',
      site: 'wa.ru',
    ),
    ShopModel(
      id: 0,
      coords: const Point(
        latitude: 55.180295,
        longitude: 61.386114,
      ),
      name: 'ЛинзСервис',
      address: 'address',
      phone: 'phone',
    ),
    ShopModel(
      id: 0,
      coords: const Point(
        latitude: 55.173414,
        longitude: 61.412624,
      ),
      name: 'Оптика-А',
      address: 'address',
      phone: 'phone',
      site: 'ds.ru',
    ),
    ShopModel(
      id: 0,
      coords: const Point(
        latitude: 55.147753,
        longitude: 61.40847,
      ),
      name: 'Оптика-А',
      address: 'address',
      phone: 'phone',
    ),
    ShopModel(
      id: 0,
      coords: const Point(
        latitude: 55.147343,
        longitude: 61.394574,
      ),
      name: 'Оптика-Б',
      address: 'address',
      phone: 'phone',
      site: 'gg.ru',
    ),
  ];
}
