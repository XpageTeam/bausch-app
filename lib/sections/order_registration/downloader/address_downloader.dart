// ignore_for_file: avoid_catches_without_on_clauses

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/profile_settings/adress_model.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';

class AddressDownloader {
  final _rh = RequestHandler();

  Future<List<AdressModel>> loadData() async {
    final parsedData = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/user/addresses/',
      ))
          .data!,
    );

    try {
      return (parsedData.data as List<dynamic>)
          // ignore: avoid_annotating_with_dynamic
          .map((dynamic address) =>
              AdressModel.fromMap(address as Map<String, dynamic>))
          .toList();
    } on ResponseParseException {
      rethrow;
    } catch (e) {
      throw ResponseParseException('AddressDownloader: $e');
    }
  }
}
