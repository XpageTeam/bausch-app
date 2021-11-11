import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/models/mappable_object.dart';

/// Модель ответа на запрос
class BaseResponseRepository
    implements MappableInterface<BaseResponseRepository> {
  /// данные в ответе на запрос
  final dynamic data;

  final Map<String, dynamic>? ubiquitous;

  /// результат выполнения запроса
  final bool success;

  /// некое сообщение
  /// обычно присутствует если [success] == false
  final String? message;

  final int? code;

  BaseResponseRepository({
    required this.data,
    required this.success,
    this.code,
    this.message,
    this.ubiquitous,
  });

  factory BaseResponseRepository.fromMap(Map<String, dynamic> map) {
    if (map['success'] is! bool) {
      throw ResponseParseExeption('ответ от сервера не содержит success');
    }

    return BaseResponseRepository(
      data: map['data'],
      success: map['success'] as bool,
      code: map['code'] != null ? map['code'] as int : null,
      message: map['message'] != null ? map['message'] as String : null,
      ubiquitous: map['ubiquitous'] != null
          ? map['ubiquitous'] as Map<String, dynamic>
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'success': success,
      if (data != null) 'data': data,
      if (message != null) 'message': message,
      if (code != null) 'code': code.toString(),
      if (ubiquitous != null) 'ubiquitous': ubiquitous,
    };
  }
}
