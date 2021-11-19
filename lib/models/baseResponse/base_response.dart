import 'package:bausch/exceptions/response_parse_exception.dart';
import 'package:bausch/exceptions/success_false.dart';
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
      throw ResponseParseException('Ответ от сервера не содержит success');
    }

    if (map['success'] == false) {
      throw SuccessFalse(map['message'] as String? ?? 'Произошла ошибка');
    }

    try {
      return BaseResponseRepository(
        data: map['data'],
        success: map['success'] as bool,
        code: map['code'] as int?,
        message: map['message'] as String?,
        ubiquitous: map['ubiquitous'] as Map<String, dynamic>?,
      );
    // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException(e.toString());
    }
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