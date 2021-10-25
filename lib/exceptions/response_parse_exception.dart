class ResponseParseExeption implements Exception {
  late final String? _message;

  ResponseParseExeption([this._message]);

  @override
  String toString() => _message ?? 'ResponseParseExeption';
}
