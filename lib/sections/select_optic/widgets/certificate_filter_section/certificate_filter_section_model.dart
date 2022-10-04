import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/animation.dart';

class CertificateFilterSectionModel {
  final List<Filter> commonFilters;
  final List<LensFilter> lensFilters;

  CertificateFilterSectionModel({
    required this.commonFilters,
    required this.lensFilters,
  });

  factory CertificateFilterSectionModel.fromJson(Map<String, dynamic> map) {
// TODO(Nikolay): Надо правильные названия из json.

    return CertificateFilterSectionModel(
      commonFilters: (map['common_filters'] as List<dynamic>)
          .map(
            (dynamic e) => Filter(id: 0, title: 'title'),
          )
          .toList(),
      lensFilters: (map['lens_filters'] as List<dynamic>).map(
        (dynamic e) {
          final map = e as Map<String, dynamic>;

          return LensFilter(
            id: 0,
            title: map['title'] as String,
            color: _getColorFromHex(map['color'] as String) ??
                AppTheme.turquoiseBlue,
          );
        },
      ).toList(),
    );
  }

  static Color? _getColorFromHex(String rawHexColor) {
    var hexColor = rawHexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    if (hexColor.length == 8) {
      return Color(int.parse('0x$hexColor'));
    }
    return null;
  }
}
