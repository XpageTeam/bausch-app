import 'package:bausch/models/shop/shop_model.dart';
import 'package:bausch/repositories/shops/shops_repository.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AbstractFilter extends Equatable {
  final int id;
  final String title;

  @override
  List<Object?> get props => [id, title];

  const AbstractFilter({
    required this.id,
    required this.title,
  });
}

class Filter extends AbstractFilter {
  const Filter({
    required super.id,
    required super.title,
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

class AbstractCertificateFilter extends AbstractFilter {
  final String xmlId;
  const AbstractCertificateFilter({
    required super.id,
    required super.title,
    required this.xmlId,
  });
}

class LensFilter extends AbstractCertificateFilter {
  final String? subtitle;
  final Color color;
  const LensFilter({
    required super.id,
    required super.title,
    required super.xmlId,
    required this.color,
    this.subtitle,
  });
}

class CommonFilter extends AbstractCertificateFilter {
  const CommonFilter({
    required super.id,
    required super.title,
    required super.xmlId,
  });
}
