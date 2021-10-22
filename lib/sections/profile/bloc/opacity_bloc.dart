import 'package:flutter_bloc/flutter_bloc.dart';

class OpacityBloc extends Bloc<double, double> {
  final double minChildSize;
  OpacityBloc({required this.minChildSize}) : super(0.0);

  @override
  Stream<double> mapEventToState(double event) async* {
    yield (event - minChildSize) / (0.89 - minChildSize);
  }
}
