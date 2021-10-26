part of 'catalogsheet_cubit.dart';

@immutable
abstract class CatalogSheetState {}

class CatalogSheetInitial extends CatalogSheetState {}

class CatalogSheetLoading extends CatalogSheetState {}

class CatalogSheetSuccess extends CatalogSheetState {
  final List<CatalogSheetModel> models;

  CatalogSheetSuccess({
    required this.models,
  });
}

class CatalogSheetFailed extends CatalogSheetState {
  final String title;
  final String? subtitle;

  CatalogSheetFailed({
    required this.title,
    this.subtitle,
  });
}
