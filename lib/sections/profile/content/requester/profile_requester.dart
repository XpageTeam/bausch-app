// ignore_for_file: avoid_catches_without_on_clauses, avoid_annotating_with_dynamic

import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/baseResponse/base_response.dart';
import 'package:bausch/packages/request_handler/request_handler.dart';
import 'package:bausch/sections/profile/content/models/base_order_model.dart';
import 'package:bausch/sections/profile/content/models/certificate_model.dart';
import 'package:bausch/sections/profile/content/models/consultation_model.dart';
import 'package:bausch/sections/profile/content/models/notification_model.dart';
import 'package:bausch/sections/profile/content/models/offline_order_model.dart';
import 'package:bausch/sections/profile/content/models/partner_model.dart';
import 'package:bausch/sections/profile/content/models/product_model.dart';
import 'package:bausch/sections/profile/content/models/webinar_model.dart';
import 'package:dio/dio.dart';

class ProfileRequester {
  final _rh = RequestHandler();

  /// Загружает историю заказов
  Future<List<BaseOrderModel?>> loadOrderHistory() async {
    final result =
        BaseResponseRepository.fromMap((await _rh.get<Map<String, dynamic>>(
      '/user/order/history/',
    ))
            .data!);

    try {
      return (result.data as List<dynamic>?)
              ?.map<BaseOrderModel?>((dynamic item) {
            item as Map<String, dynamic>;

            // debugPrint('item: $item');
            var category = item['category'] as String?;
            if (category != null) {
              category = category.contains('online') &&
                      category != 'online_consultation'
                  ? 'discount'
                  : category;
            }

            switch (category) {
              case 'webinar':
                return WebinarOrderModel.fromMap(item);

              case 'certificate':
                return CertificateOrderModel.fromMap(item);

              case 'online_consultation':
                return ConsultationOrderModel.fromMap(item);

              case 'product':
              case 'online':
                return ProductOrderModel.fromMap(item);

              case 'partner':
                return PartnerOrderModel.fromMap(item);

              case 'offline':
              case 'discount':
                return OfflineOrderModel.fromMap(item);

              default:
                return null;
            }
          }).toList() ??
          [];
    } catch (e) {
      throw ResponseParseException('loadOrderHistory: ${e.toString()}');
    }
  }

  /// загружает историю уведомлений
  Future<List<NotificationModel>> loadNotificationsList() async {
    final result = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/user/notifications/',
      ))
          .data!,
    );
    try {
      return (result.data as List<dynamic>)
          .map(
            (dynamic item) =>
                NotificationModel.fromMap(item as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      throw ResponseParseException('loadNotificationsList: ${e.toString()}');
    }
  }

  Future<void> sendNotificationsRead({required List<int> ids}) async {
    final rh = RequestHandler();

    try {
      BaseResponseRepository.fromMap((await rh.post<Map<String, dynamic>>(
        '/user/notifications/read/',
        data: FormData.fromMap(<String, dynamic>{
          'notification_id[]': ids,
        }),
      ))
          .data!);
    } catch (e) {
      throw ResponseParseException('sendNotificationsRead: ${e.toString()}');
    }
  }

  /*
  Future<List<Offer>?> loadNotificationsBanners() async {
    final result = BaseResponseRepository.fromMap(
      (await _rh.get<Map<String, dynamic>>(
        '/banner/?type=notifications',
      ))
          .data!,
    );

    try {
      return (result.data as List<dynamic>).map((dynamic item) {
        return Offer.fromJson(item as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('loadNotificationsBanners: $e');
    }
  }*/
}
