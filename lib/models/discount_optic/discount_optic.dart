// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/help/help_functions.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class DiscountOptic {
  final int id;
  final String title;
  final String shopCode;
  final String? logo;
  final String link;
  final List<DiscountOpticShop>? disountOpticShops;
  final List<String>? cities;

  DiscountOptic({
    required this.id,
    required this.title,
    required this.shopCode,
    required this.link,
    required this.disountOpticShops,
    this.logo,
    this.cities,
  });

  factory DiscountOptic.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      ResponseParseException('Не передан id оптики со скидкой');
    }

    try {
      return DiscountOptic(
        id: json['id'] as int,
        title: json['title'] as String,
        shopCode: json['shopCode'] as String,
        logo: json['logo'] as String?,
        link: json['link'] as String,
        disountOpticShops: json['shop_data'] != null
            ? List<DiscountOpticShop>.from(
                (json['shop_data'] as List<dynamic>).map<DiscountOpticShop>(
                  // ignore: avoid_annotating_with_dynamic
                  (dynamic x) => DiscountOpticShop.fromJson(
                    x as Map<String, dynamic>,
                  ),
                ),
              )
            : null,
        cities: json['cities'] != null
            ? List<String>.from(
                (json['cities'] as List<dynamic>)
                    // ignore: avoid_annotating_with_dynamic
                    .map<String>((dynamic e) => e as String),
              ).toList()
            : null,
      );
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
  }
}

class DiscountOpticShop {
  final int id;
  final List<String> phone;
  final String address;
  final String email;
  final Point coord;
  final String city;

  DiscountOpticShop({
    required this.id,
    required this.phone,
    required this.address,
    required this.email,
    required this.coord,
    required this.city,
  });

  factory DiscountOpticShop.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      ResponseParseException('Не передан id магазина со скидкой');
    }
    return DiscountOpticShop(
      id: json['id'] as int,
      phone: List<String>.from(
        (json['phone'] as List<dynamic>).map<String>(
          // ignore: avoid_annotating_with_dynamic
          (dynamic x) => HelpFunctions.formatPhone(x as String),
        ),
      ),
      address: json['address'] as String,
      email: json['email'] as String,
      coord: Point(
        latitude: double.parse(
          (json['coord'] as Map<String, dynamic>)['lat'] as String,
        ),
        longitude: double.parse(
          (json['coord'] as Map<String, dynamic>)['lng'] as String,
        ),
      ),
      city: json['city'] as String,
    );
  }
}
