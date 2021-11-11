part of 'rules_cubit.dart';

@immutable
abstract class RulesState {}

class RulesInitial extends RulesState {}

class RulesLoading extends RulesState {}

class RulesSuccess extends RulesState {
  final String data;

  RulesSuccess({required this.data});
}

class RulesFailed extends RulesState {
  final String title;
  final String? subtitle;

  RulesFailed({required this.title, this.subtitle});
}
