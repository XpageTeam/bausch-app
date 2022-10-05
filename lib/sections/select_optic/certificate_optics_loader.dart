import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/select_optic/widgets/certificate_filter_section/certificate_filter_section_model.dart';
import 'package:bausch/sections/sheets/screens/discount_optics/widget_models/discount_optics_screen_wm.dart';
import 'package:flutter/foundation.dart';

// /optics/city/?cityId=385030
class CertificateOpticsLoader {
  static Future<List<OpticShopForCertificate>> loadByCityId(int cityId) async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        '/optics/city/',
        queryParameters: <String, dynamic>{'cityId': cityId},
      ))
          .data!,
    );
    return (res.data as List<dynamic>)
        .map(
          // ignore: avoid_annotating_with_dynamic
          (dynamic e) =>
              OpticShopForCertificate.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  // /optics/filters/
  static Future<CertificateFilterSectionModel> loadFilters() async {
    final rh = RequestHandler();

    final res = BaseResponseRepository.fromMap(
      (await rh.get<Map<String, dynamic>>(
        '/optics/filters/',
      ))
          .data!,
    );

    final json = res.data as Map<String, dynamic>;
    // debugPrint('json: $json');
    return CertificateFilterSectionModel.fromJson(json);
  }
}
