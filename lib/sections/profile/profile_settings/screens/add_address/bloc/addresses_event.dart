part of 'addresses_bloc.dart';

@immutable
abstract class AddressesEvent {
  const AddressesEvent();
}

class AddressesSend extends AddressesEvent {
  final AdressModel address;

  const AddressesSend({required this.address});
}

class AddressUpdate extends AddressesEvent {
  final AdressModel address;

  const AddressUpdate({required this.address});
}

class AddressesDelete extends AddressesEvent {
  final int id;

  const AddressesDelete({required this.id});
}
