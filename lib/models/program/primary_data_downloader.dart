import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/models/program/primary_data.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';

class PrimaryDataDownloader {
  static Future<PrimaryData> load() async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        '/selection/data/',
      ))
          .data!,
    );

    return PrimaryData.fromJson(res.data as Map<String, dynamic>);
  }
}
