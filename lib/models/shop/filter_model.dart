import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';

class Filter {
  final int id;
  final String title;

  const Filter({
    required this.id,
    required this.title,
  });

  static List<Filter> getFiltersFromShopList(List<ShopModel> shops) {
    final filtersMap = <String, Filter>{
      'Все оптики': const Filter(
        id: 0,
        title: 'Все оптики',
      ),
    };
    var id = 1;

    for (final shop in shops) {
      if (filtersMap[shop.name] == null) {
        filtersMap.addAll(
          <String, Filter>{
            shop.name: Filter(
              id: id,
              title: shop.name,
            ),
          },
        );
        id++;
      }
    }

    return filtersMap.values.toList();
  }

  static List<Filter> getFiltersFromOpticList(List<Optic> optics) {
    final filtersMap = <String, Filter>{
      'Все оптики': const Filter(
        id: 0,
        title: 'Все оптики',
      ),
    };
    var id = 1;

    for (final shop in optics) {
      if (filtersMap[shop.title] == null) {
        filtersMap.addAll(
          <String, Filter>{
            shop.title: Filter(
              id: id,
              title: shop.title,
            ),
          },
        );
        id++;
      }
    }

    return filtersMap.values.toList();
  }

  static List<Filter> getFiltersFromCityList(List<CityModel> cities) {
    final shops = <ShopModel>[];

    for (final city in cities) {
      shops.addAll(city.shopsRepository.shops);
    }

    final filtersMap = <String, Filter>{
      'Все оптики': const Filter(
        id: 0,
        title: 'Все оптики',
      ),
    };
    var id = 1;

    for (final shop in shops) {
      if (filtersMap[shop.name] == null) {
        filtersMap.addAll(
          <String, Filter>{
            shop.name: Filter(
              id: id,
              title: shop.name,
            ),
          },
        );
        id++;
      }
    }

    return filtersMap.values.toList();
  }
}
