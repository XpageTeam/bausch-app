import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'shoplist_state.dart';

class ShopListCubit extends Cubit<ShopListState> {
  String? city;

  ShopListCubit({
    this.city,
  }) : super(ShopListInitial());

  CitiesRepository? citiesRepository;

  Future<void> loadShopList() async {
    if (citiesRepository == null) {
      emit(ShopListLoading());
      emit(await _loadShopList());
    } else {
      emit(
        ShopListSuccess(
          cityList: citiesRepository!.cities,
        ),
      );
    }
  }

  // Future<void> loadShopListByCity(String city) async {
  //   emit(ShopListLoading());
  //   emit(await _loadShopListByCity(city));
  // }

  Future<ShopListState> _loadShopList() async {
    try {
      citiesRepository = await CitiesWithShopsDownloader.load();

      // if (!citiesRepository.cities.any(
      //   (element) => element.name == city,
      // )) {
      //   return ShopListEmpty();
      // } else {
      //   return ShopListSuccess(
      //     cityList: citiesRepository.cities,
      //   );
      // }
      return ShopListSuccess(
        cityList: citiesRepository!.cities,
      );
    } on DioError catch (e) {
      return ShopListFailed(
        title: 'Ошибка при отправке запроса на сервер',
        text: e.message,
      );
    } on ResponseParseException catch (e) {
      return ShopListFailed(
        title: 'Ошибка при получении ответа с сервера',
        text: e.toString(),
      );
    } on SuccessFalse catch (e) {
      return ShopListFailed(
        title: 'Произошла ошибка',
        text: e.toString(),
      );
    }
  }

  // Future<ShopListState> _loadShopListByCity(String city) async {
  //   try {
  //     final citiesRepository = await CitiesWithShopsDownloader.load();
  //     return ShopListSuccess(
  //       cityList: citiesRepository.getCityListByCityName(city),
  //     );
  //   } on DioError catch (e) {
  //     return ShopListFailed(
  //       title: 'Problems???? (интернет)',
  //       text: e.message,
  //     );
  //   } on ResponseParseException catch (e) {
  //     return ShopListFailed(
  //       title: 'Problems???? (парсинг)',
  //       text: e.toString(),
  //     );
  //   } on SuccessFalse catch (e) {
  //     return ShopListFailed(
  //       title: 'Problems???? (суксес фолс)',
  //       text: e.toString(),
  //     );
  //   }
  // }
}
