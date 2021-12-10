part of 'addresses_bloc.dart';

@immutable
abstract class AddressesEvent {}

class AddressesSend extends AddressesEvent {
  final AdressModel address;

  AddressesSend({required this.address});
}

class AddressesDelete extends AddressesEvent {
  final int id;

  AddressesDelete({required this.id});
}
