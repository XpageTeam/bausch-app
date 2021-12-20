import 'package:bausch/models/discount_optic/discount_optic.dart';

class DiscountOpticsRepository {
  final List<DiscountOptic> discountOptics;

  DiscountOpticsRepository({
    required this.discountOptics,
  });

  factory DiscountOpticsRepository.fromList(List<dynamic> json) =>
      DiscountOpticsRepository(
        discountOptics: List<DiscountOptic>.from(
          json.map<DiscountOptic>(
            // ignore: avoid_annotating_with_dynamic
            (dynamic x) => DiscountOptic.fromJson(x as Map<String, dynamic>),
          ),
        ),
      );
}
