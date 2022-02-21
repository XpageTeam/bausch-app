// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';

class SpecificationsModel {
  final List<String>? diopters;
  final List<String>? cylinder;
  final List<String>? axis;
  final List<String>? addiction;
  final List<String>? color;

  SpecificationsModel({
    this.diopters,
    this.cylinder,
    this.axis,
    this.addiction,
    this.color,
  });

  factory SpecificationsModel.fromMap(Map<String, dynamic> map) {
    try {
      return SpecificationsModel(
        diopters: map['diopters'] != null
            ? (map['diopters'] as List<dynamic>)
                // ignore: avoid_annotating_with_dynamic
                .map((dynamic e) => e as String)
                .toList()
            : null,
        cylinder: map['cylinder'] != null
            ? (map['cylinder'] as List<dynamic>)
                // ignore: avoid_annotating_with_dynamic
                .map((dynamic e) => e as String)
                .toList()
            : null,
        axis: map['axis'] != null
            ? (map['axis'] as List<dynamic>)
                // ignore: avoid_annotating_with_dynamic
                .map((dynamic e) => e as String)
                .toList()
            : null,
        addiction: map['addiction'] != null
            ? (map['addiction'] as List<dynamic>)
                // ignore: avoid_annotating_with_dynamic
                .map((dynamic e) => e as String)
                .toList()
            : null,
        color: map['color'] != null
            ? (map['color'] as List<dynamic>)
                // ignore: avoid_annotating_with_dynamic
                .map((dynamic e) => e as String)
                .toList()
            : null,
      );
    } catch (e) {
      throw ResponseParseException('SpecificationsModel: $e');
    }
  }
}
