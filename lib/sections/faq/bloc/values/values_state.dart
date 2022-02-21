part of 'values_bloc.dart';

@immutable
abstract class ValuesState {
  final List<ValueModel> values;

  const ValuesState({required this.values});
}

class ValuesInitial extends ValuesState {
  const ValuesInitial() : super(values: const []);
}

class ValuesLoading extends ValuesState {
  const ValuesLoading() : super(values: const []);
}

class ValuesFailed extends ValuesState {
  final String title;
  final String? subtitle;

  const ValuesFailed({required this.title, this.subtitle})
      : super(values: const []);
}

class ValuesSuccess extends ValuesState {
  const ValuesSuccess({required List<ValueModel> values})
      : super(values: values);
}
