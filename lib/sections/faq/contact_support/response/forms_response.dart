import 'package:bausch/exceptions/response_parse_exception.dart';

class FormsResponse {
  final String? title;
  final String? subtitle;

  FormsResponse({
    required this.title,
    this.subtitle,
  });

  factory FormsResponse.fromMap(Map<String, dynamic> map) {
    try {
      return FormsResponse(
        title: map['title'] as String?,
        subtitle: map['subtitle'] as String?,
      );
    } catch (e) {
      throw ResponseParseException('FormsResponse: $e');
    }
  }
}
