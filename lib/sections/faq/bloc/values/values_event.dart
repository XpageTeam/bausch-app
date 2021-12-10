part of 'values_bloc.dart';

@immutable
abstract class ValuesEvent {}

class UpdateValues extends ValuesEvent {
  final int id;

  UpdateValues({required this.id});
}
