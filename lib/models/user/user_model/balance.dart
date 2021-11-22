import 'package:bausch/models/user/user_model/nearest_expiration.dart';
import 'package:flutter/foundation.dart';

@immutable
class Balance {
  final num total;
  final num available;
  final NearestExpiration? nearestExpiration;

  const Balance({
    required this.total,
    required this.available,
    this.nearestExpiration,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        total: json['total'] as num,
        available: json['available'] as num,
        nearestExpiration: json['nearestExpiration'] == null
            ? null
            : NearestExpiration.fromJson(
                json['nearestExpiration'] as Map<String, dynamic>,
              ),
      );

  @override
  String toString() {
    return 'Balance(total: $total, available: $available, nearestExpiration: $nearestExpiration)';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'total': total,
        'available': available,
        'nearestExpiration': nearestExpiration?.toJson(),
      };

  Balance copyWith({
    int? total,
    int? available,
    NearestExpiration? nearestExpiration,
  }) {
    return Balance(
      total: total ?? this.total,
      available: available ?? this.available,
      nearestExpiration: nearestExpiration ?? this.nearestExpiration,
    );
  }
}
