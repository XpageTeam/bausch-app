import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class ShopsRepository {
  final List<ShopModel> shops;

  const ShopsRepository({
    required this.shops,
  });

  factory ShopsRepository.fromList(List<dynamic> rawList) {
    final shops = <ShopModel>[];
    for (final shop in rawList) {
      shops.add(
        ShopModel.fromJson(shop as Map<String, dynamic>),
      );
    }

    return ShopsRepository(
      shops: shops,
    );
  }
}

class CitiesRepository {
  final List<CityModel> cities;

  List<ShopModel> get shopList {
    final shops = <ShopModel>[];

    for (final city in cities) {
      shops.addAll(city.shopsRepository.shops);
    }

    return shops;
  }

  const CitiesRepository({
    required this.cities,
  });

  factory CitiesRepository.fromList(List<dynamic> rawList) {
    final cities = <CityModel>[];
    for (final rawCity in rawList) {
      final city = CityModel.fromJson(rawCity as Map<String, dynamic>);
      cities.add(city);
    }

    return CitiesRepository(
      cities: cities,
    );
  }

  List<ShopModel> getShopListByCity(String cityName) {
    final containsCity = cities.any(
      (city) => city.name == cityName,
    );

    if (cities.isEmpty || !containsCity) return <ShopModel>[];

    final filteredByCity = cities.firstWhere(
      (city) => city.name == cityName,
    );

    return filteredByCity.shopsRepository.shops;
  }

  List<CityModel> getCityListByCityName(String cityName) {
    final containsCity = cities.any(
      (city) => city.name == cityName,
    );

    if (cities.isEmpty || !containsCity) return <CityModel>[];

    final filteredByCity = cities.where(
      (city) => city.name == cityName,
    );

    return filteredByCity.toList();
  }
}

class CityModel {
  final int id;

  final String name;

  final ShopsRepository shopsRepository;

  CityModel({
    required this.id,
    required this.name,
    required this.shopsRepository,
  });

  factory CityModel.fromJson(Map<String, dynamic> map) {
    if (map['id'] == null) {
      throw ResponseParseException('У города отсутствует идентификатор');
    }

    return CityModel(
      id: map['id'] as int,
      name: map['name'] as String,
      shopsRepository: ShopsRepository.fromList(
        map['offices'] as List<dynamic>,
      ),
    );
  }
}

class AllOpticsDownloader{
  
  static Future<CitiesRepository> load() async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        '/optics/',
      ))
          .data!,
    );

    return CitiesRepository.fromList(res.data as List<dynamic>);
  }
}
