import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/program/primary_data.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';

class PrimaryDataDownloader {
  static Future<PrimaryData> load() async {
    final rh = RequestHandler();
    try {
      final res = BaseResponseRepository.fromMap(
        (await rh.get<Map<String, dynamic>>(
          '/selection/data/',
        ))
            .data!,
      );
      return PrimaryData.fromJson(res.data as Map<String, dynamic>);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
    // TODO(pavlov): ошибка 301
      throw ResponseParseException('Ошибка в primary data downloader: $e');
    }
  }
}
