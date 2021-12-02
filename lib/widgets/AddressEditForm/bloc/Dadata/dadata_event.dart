part of 'dadata_bloc.dart';

abstract class DadataEvent {}

class DadataChangeText extends DadataEvent {
  final String text;

  DadataChangeText({required this.text});
}
