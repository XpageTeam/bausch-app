part of 'values_bloc.dart';

@immutable
abstract class ValuesEvent {
  const ValuesEvent();
}

class UpdateValues extends ValuesEvent {
  final int id;

  const UpdateValues({required this.id});
}
