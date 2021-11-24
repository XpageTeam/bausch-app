part of 'values_bloc.dart';

@immutable
abstract class ValuesState {
  final List<ValueModel> values;

  ValuesState({required this.values});
}

class ValuesInitial extends ValuesState {
  ValuesInitial() : super(values: []);
}

class ValuesLoading extends ValuesState {
  ValuesLoading() : super(values: []);
}

class ValuesFailed extends ValuesState {
  final String title;
  final String? subtitle;

  ValuesFailed({required this.title, this.subtitle}) : super(values: []);
}

class ValuesSuccess extends ValuesState {
  ValuesSuccess({required List<ValueModel> values}) : super(values: values);
}
