import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fields_event.dart';
part 'fields_state.dart';

class FieldsBloc extends Bloc<FieldsEvent, FieldsState> {
  FieldsBloc() : super(FieldsInitial());

  @override
  Stream<FieldsState> mapEventToState(
    FieldsEvent event,
  ) async* {}
}
