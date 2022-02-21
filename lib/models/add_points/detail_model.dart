// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class DetailModel {
  final String title;

  final String icon;

  final String? description;

  final String? btnName;

  final String? btnIcon;

  DetailModel({
    required this.title,
    required this.icon,
    this.description,
    this.btnName,
    this.btnIcon,
  });

  factory DetailModel.fromMap(Map<String, dynamic> map) {
    try {
      return DetailModel(
        title: (map['title'] ?? 'title') as String,
        icon: (map['icon'] ??
                'https://bausch.in-progress.ru/upload/uf/4fa/0ds4e7fo757lrxzlbxn5ji44co0vow8h.png')
            as String,
        description: map['description'] as String?,
        btnName: map['btn_name'] as String?,
        btnIcon: map['btn_icon'] as String?,
      );
    } catch (e) {
      throw ResponseParseException('DetailModel: $e');
    }
  }
}
