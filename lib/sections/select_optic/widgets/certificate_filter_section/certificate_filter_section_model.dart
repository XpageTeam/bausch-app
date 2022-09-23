import 'package:bausch/models/shop/filter_model.dart';

class CertificateFilterSectionModel {
  final List<Filter> commonFilters;
  final List<Filter> lensFilters;

  CertificateFilterSectionModel({
    required this.commonFilters,
    required this.lensFilters,
  });
}
