part of 'dadata_bloc.dart';

abstract class DadataEvent {
  const DadataEvent();
}

class DadataChangeText extends DadataEvent {
  final String text;

  DadataChangeText({required this.text});
}

class DadataSetEmptyField extends DadataEvent {}
