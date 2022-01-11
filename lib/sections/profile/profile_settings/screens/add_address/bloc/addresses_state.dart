part of 'addresses_bloc.dart';

@immutable
abstract class AddressesState {
  const AddressesState();
}

class AddressesInitial extends AddressesState {}

class AddressesSending extends AddressesState {}

class AddressesSended extends AddressesState {}

class AddressesFailed extends AddressesState {
  final String title;
  final String? subtitle;

  const AddressesFailed({
    required this.title,
    this.subtitle,
  });
}
