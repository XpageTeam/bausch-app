part of 'page_switcher_cubit_cubit.dart';

@immutable
abstract class PageSwitcherState {
  const PageSwitcherState();
}

class PageSwitcherInitial extends PageSwitcherState {}

class PageSwitcherShowMap extends PageSwitcherState {}

class PageSwitcherShowList extends PageSwitcherState {}
