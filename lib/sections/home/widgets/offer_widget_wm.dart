import 'package:surf_mwwm/surf_mwwm.dart';

class OfferWidgetWM extends WidgetModel {
  final List<String> remainingStrings = [];
  final remainingString = StreamedState<String>('');
  OfferWidgetWM() : super(const WidgetModelDependencies());
}
