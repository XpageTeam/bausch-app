class SuccessFalse implements Exception {
	late final String? _message;

	SuccessFalse([this._message]);

	@override
	String toString() => _message ?? 'ResponseParseExeption';
}