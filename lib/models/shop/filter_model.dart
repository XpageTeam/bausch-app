import 'package:bausch/models/shop/shop_model.dart';

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
}
