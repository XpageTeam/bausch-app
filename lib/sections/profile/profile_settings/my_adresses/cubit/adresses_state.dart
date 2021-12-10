part of 'adresses_cubit.dart';

@immutable
abstract class AdressesState {}

class AdressesInitial extends AdressesState {}

class AdressesLoading extends AdressesState {}

class GetAdressesSuccess extends AdressesState {
  final List<AdressModel> adresses;

  GetAdressesSuccess({required this.adresses});
}

class AdressesFailed extends AdressesState {
  final String title;
  final String? subtitle;

  AdressesFailed({
    required this.title,
    this.subtitle,
  });
}
