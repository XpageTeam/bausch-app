// ignore_for_file: avoid_annotating_with_dynamic

import 'package:bausch/models/shop/filter_model.dart';
import 'package:bausch/theme/app_theme.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

class CertificateFilterSectionModel {
  final List<CommonFilter> commonFilters;
  final List<LensFilter> lensFilters;

  CertificateFilterSectionModel({
    required this.commonFilters,
    required this.lensFilters,
  });

  factory CertificateFilterSectionModel.fromJson(Map<String, dynamic> map) {
    return CertificateFilterSectionModel(
      commonFilters: (map['common'] as List<dynamic>).map(
        (dynamic e) {
          final map = e as Map<String, dynamic>;

          return CommonFilter(
            id: 0,
            title: map['name'] as String,
            xmlId: map['xml_id'] as String,
          );
        },
      ).toList(),
      lensFilters: (map['lensSelection'] as List<dynamic>).map(
        (dynamic e) {
          final map = e as Map<String, dynamic>;

          return LensFilter(
            id: 0,
            title: map['name'] as String,
            xmlId: map['xml_id'] as String,
            color: _getColorFromHex(map['color'] as String?) ??
                AppTheme.turquoiseBlue,
          );
        },
      ).toList(),
    );
  }

  static Color? _getColorFromHex(String? rawHexColor) {
    if (rawHexColor == null) return null;

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
