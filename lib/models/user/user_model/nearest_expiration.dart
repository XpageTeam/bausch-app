import 'package:flutter/foundation.dart';

@immutable
class NearestExpiration {
	final num? amount;
	final DateTime? date;

	const NearestExpiration({this.amount, this.date});

	factory NearestExpiration.fromJson(Map<String, dynamic> json) {
		return NearestExpiration(
			amount: json['amount'] as num?,
			date: json['date'] == null
						? null
						: DateTime.parse(json['date'] as String),
		);
	}

	@override
	String toString() => 'NearestExpiration(amount: $amount, date: $date)';

	Map<String, dynamic> toJson() => <String, dynamic>{
				'amount': amount,
				'date': date?.toIso8601String(),
			};

		NearestExpiration copyWith({
		int? amount,
		DateTime? date,
	}) {
		return NearestExpiration(
			amount: amount ?? this.amount,
			date: date ?? this.date,
		);
	}
}
