part of 'dadata_bloc.dart';

abstract class DadataState {
  const DadataState();
}

class DadataInitial extends DadataState {}

class DadataLoading extends DadataState {}

class DadataSuccess extends DadataState {
  final List<DadataResponseModel> models;

  DadataSuccess({required this.models});
}

class DadataFailed extends DadataState {
  final String title;
  final String? subtitle;

  DadataFailed({required this.title, this.subtitle});
}
